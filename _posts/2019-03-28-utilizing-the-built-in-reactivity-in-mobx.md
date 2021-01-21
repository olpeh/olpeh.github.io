---
title: 'Utilizing the built-in reactivity in MobX'
date: 2019-03-28 00:00:00 Z
layout: post
excerpt: 'MobX is an easy-to-use state handling library for web frontend projects, but it also ccomes with powerful features built-in. This blog post show cases using reactions.'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
image: '/images/09-mobx/mobx.png'
altText: 'MobX logo'
---

## Background

At the current client project I work at, we have used (P)react + MobX in 4 different web projects over the course of the past 2 years. This blog post is not an introduction to this tech stack, but a showcase for a neat trick I used to solve a problem.

## The Problem

We are currently building a web project that consists of multiple small widgets that can be embedded on their own in an iframe. This requirement has lead us to a design where each widget on a page fetch their own data when the components get mounted. We have multiple small MobX stores in order to keep the file sizes small and the stores easy to maintain and reason about. Most of the embeddable widgets have their own MobX store that they utilize. Some common stores are injected to the components if needed. This seems to work well so far.

However, we now need to include a refresh button on the top of the page, that would refresh the data in all of the widgets on the page. However, the widgets are independent and don’t know about the other widgets on the same page. This is an interesting problem and we decided to try to come up with the best possible solution.

### Possible Solutions

The easiest solution would be to have the refresh button refresh the whole browser tab, which would then end up in refreshing the data as well. This is not optimal from performance or user experience point-of-view.

```ts
<button onClick={() => location.reload(true)}>Refresh</button>
```

Another solution we came up with was to have a common store that would have a refresh method that could be triggered from the refresh button click. This is not optimal since the global store would not be able to know what widgets are actually on the page and it would end up refreshing everything instead of only those widgets that need to be refreshed.

The code would then look something like this:

```ts
export class GlobalSharedStore {
    // Imaginary array that contains all the stores that
    // need to be refreshed when refresh button is clicked
    stores = [];

    refreshAll() {
        this.stores.forEach(store => store.refresh());
    }
  }
}
```

This is not optimal and definitely not reactive.

## The MobX Way

How about utilizing the power of MobX?

MobX comes with built-in reactivity, where you don’t need to think about it too much unless you need to understand MobX in depth. Mobx has multiple ways to react to observables, and [one of them is reactions](https://mobx.js.org/refguide/reaction.html){:target="\_blank"}{:rel="noopener noreferrer"}.

From the MobX documentation:

> “It is important to notice that the side effect will only react to data that was accessed in the data expression, which might be less than the data that is actually used in the effect. Also, the side effect will only be triggered when the data returned by the expression has changed. In other words: reaction requires you to produce the things you need in your side effect.” <br/>
> – Source: [MobX Documentation](https://mobx.js.org/refguide/reaction.html){:target="\_blank"}{:rel="noopener noreferrer"}

In short, a reaction is a way to define a function that gets triggered every time the observable properties defined in the reaction change. A reaction seems to be exactly what we need in order to solve this problem of refreshing data in independent widgets. We created an observable property called `refreshTrigger` which is a `number` in order to easily trigger a change by simply incrementing the number. This flag needs to be in a shared store, in our case `flagStore`.

A slightly simplified version of `flagStore`:

```ts
export class FlagStore {
  @observable
  refreshTrigger: number = 0;

  @action
  triggerRefresh() {
    this.refreshTrigger++;
  }
}
```

We would then utilize this by creating an abstract class called `Refreshable` that looks like this:

```ts
import { FlagStore } from './FlagStore';
import { reaction, IReactionPublic } from 'mobx';

export abstract class RefreshableStore {
  private _reaction: IReactionPublic;

  constructor(flagStore: FlagStore) {
    reaction(
      // First param is a function that returns the data that
      // we want to react to when it changes
      () => flagStore.refreshTrigger,
      // Second param is a function that receives the data and
      // a reaction that can be used to dispose the reaction
      // In our case we don't care about the value of the refreshTrigger
      (_, r) => {
        this.fetchData();
        this._reaction = r;
      }
    );
  }

  // Abstract method that needs to be implemented
  // by classes that extend RefreshableStore
  abstract fetchData(): Promise<unknown>;

  // Dispose the reaction, in order to not react anymore
  // Called in componentWillUnmount in order to not fetch data
  // for components that are not mounted anymore
  dispose() {
    if (this._reaction) {
      this._reaction.dispose();
    }
  }
}
```

In our case, though we don’t care about the `refreshTrigger` value, we only care about the fact that it changed, and a refresh should get triggered.

How does a component and store that utilizes this feature look like?

This is how the component code looks like:

```ts
import { h, Component } from 'preact';
import { Store } from './store';
import { observer, inject } from 'mobx-preact';
import { FlagStore } from 'stores/FlagStore';

export interface Props {
  flagStore?: FlagStore;
}

@inject('flagStore')
@observer
export class ExampleComponent extends Component<Props> {
  store: Store;

  constructor(props: Props) {
    super(props);
    this.store = new Store(props.flagStore);
  }

  componentDidMount() {
    this.store.fetchData();
  }

  componentWillUnmount() {
    this.store.dispose();
  }

  render() {
    return <div>Irrelevant</div>;
  }
}
```

And the `Store` looks like this:

```ts
import { RefreshableStore } from 'stores/RefreshableStore';
import { action } from 'mobx';

export class Store extends RefreshableStore {
  @action
  fetchData() {
    // Implementation for fetchdata here
  }

  // Nothing more needed here, the store will react to the refreshTrigger
  // and refetch the data if the component is mounted
}
```

This approach makes sure no unneeded refreshes happen, since only those widgets that are on the page react to the trigger.

## Future Work

Now with this approach, we need to make sure all of the stores that have data that should be refreshed in reaction to a refresh button click utilize the `RefreshableStore`.
This may become tedious to maintain and may cause some of the data to not be always refreshed in the future.

## Acknowledgements

- Thanks to my colleagues Markus and Farzad for helping me with the implementation and reviewing this blog post
