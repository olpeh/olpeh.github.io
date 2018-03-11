---
title: I Learned Functional Reactive Programming by Learning Cycle.js
date: 2018-03-11 00:00:00 Z
layout: post
excerpt: "An introduction to Cycle.js and a story of what I learned while building Meeting Price Calculator"
author: "Olavi Haapala"
author_twitter: "0lpeh"
thumbnail: "/images/02-frp-cyclejs/cyclejs.svg"
---

In this blog post, I am writing about my experiences in learning Functional Reactive Programming (FRP) by writing an application in Cycle.js. First I'll try to explain the basics of Cycle.js and FRP. Later on in the blog post I will write about my learnings while building [Meeting Price Calculator](https://mpc.olpe.fi/) using Cycle.js. When I started learning Cycle.js, I did not know what Reactive Programming was and I had not been doing any Functional Programming either.

<img src="{{ "/images/02-frp-cyclejs/cyclejs.svg" | absolute_url }}" width="120" aria-hidden="true">

## Background

You might not have heard about Cycle.js since it is not as popular as React or Vue or others.
However, it's a proper and mature JS Framework used in production by several projects.

`"Oh yeah, yet another JS Framework"` – you might think.

That's not the case with Cycle.js. It's different. It's not like any other framework out there. Later in this post, I'll try to explain the basics of Cycle.js and why it's different.

I first about Cycle.js in 2015 when I started as a summer employee at [Futurice](https://futurice.com). [Andre Staltz](https://staltz.com/about.html), the creator of Cycle.js, used to work at Futurice as well and was demoing it in a WWWeeklies presentation. I got interested in it and tried it out for a bit. Later that summer I was also part of an internal project where we started using Cycle.js. However, it was not before March 2017 that I really started building something with Cycle.js. Later in this blog post I'll introduce the thing I started building. So, I'm no expert in Cycle.js or FRP, but I'll try to explain things as I understand them and how I learned them. If you have any feedback on the content of this blog post, I'll gladly hear about that.

So, back to what Cycle.js is. Let's see what the official documentation describes it like:

>A functional and reactive JavaScript framework for predictable code

Source: [cycle.js.org](http://cycle.js.org/)


In order to understand what that means, you have to understand the following three concepts:

1. Functional Programming (FP)
1. Reactive Programming (RP)
1. Predictable code

I will do my best in trying to explain what these mean in a simple and understandable way.

### What is Functional Programming (FP)?

Functional Programming is a popular programming paradigm where the main idea is to avoid using global state, mutable data or side-effects. In FP, data flow through `pure functions`, meaning that the function has no side effects. Side effects means changing something outside the function scope, like changing a global variable.

A super simple example of a function that does *not* follow the functional paradigm

```JS
let counter = 0
const incrementCounter = () => counter += 1;
```

The same function as a pure function that has no side effects

```JS
const incrementCounter = counter => counter + 1;
```

If the ES6 arrow function syntax is unfamiliar to you, the firs one means a function that takes no parameters and after the arrow (`=>`) is the function body. In the second example, the function takes one parameter and returns that parameter incremented. Curly braces or return statement are not needed

The main difference here is that the first example mutates a global variable as opposed to the second example, which takes a variable called `counter` and returns a new variable that is the `counter` incremented by 1.

FP is of course a lot more than this and I'm no hard-core-FP-enthusiast, but for now understanding the basic ideology is enough. Learning functional programming will help you write code that is easy to test and maintain. Testing a pure function is easy, since you don't need to mock anything. Just pass the inputs and check if the outputs are as expected. More about testing Cycle.js applications later in this blog post.

### What is Reactive Programming (RP)?

Reactive Programming is a programming paradigm based on using asynchronous streams.

A good example of reactivity is using formulas in Excel. The visible values are immediately reacting to the changes in the data. You don't have to call any update functions to update the calculations, but in contrary the cells react to changes in the data.

Another good example of RP is when you are listening to a presentation, you are `subscribing` to the presentation. When the presentation ends, the presenter does not need to tell you to go get coffee or something else. In stead, you react to the event of the presentation ending and you decide for yourself how to react to that event, what to do next.

### What is FRP then?

FRP is simply combines both functional and reactive paradigms, picking the best of both worlds. Cycle.js is a nice example of combining these two.

### Predictable code?

It's probably a bit controversial and subjective to say that some code is predictable and something is not. However, using FRP paradigms consistently may result in easily testable and predictable code. This is the case with Cycle.js. You can see the interaction and data flow by reading the code, without having to think about global state or event listeners defined in another file etc. In reactive code, you can see the interactions happening in because you control how to react to different events and not the other way round like in imperative programming.

Of course, in the end it's up to you how organized and predictable code you write. One of the good things with Cycle.js code is that it's basically just TypeScript (or JS), but that's also a horrible thing on the other hand as you might know if you have used JS/TS for a while.

## What is Cycle.js and why is it different?

So, now that we have the required background knowledge, we'll dip deeper into explaining what Cycle.js is and why it's different from the other frameworks out there.

TODO: Write about the basics of Cycle.js

### How does it look like?

Now you might be wondering, how does Cycle.js look like.

Here is a simple example application:

```JS
import xs from "xstream";
import { run } from "@cycle/run";
import { div, input, p, makeDOMDriver } from "@cycle/dom";

function main(sources) {
  const sinks = {
    DOM: sources.DOM.select("input")
      .events("change")
      .map(ev => ev.target.checked)
      .startWith(false)
      .map(toggled =>
        div([
          input({ attrs: { type: "checkbox" } }),
          "Toggle me",
          p(toggled ? "ON" : "off")
        ])
      )
  };
  return sinks;
}

const drivers = {
  DOM: makeDOMDriver("#app")
};

run(main, drivers);

```
TODO: Walk through the example code

## Model-View-Intent (MVI)

TODO: Explain MVI

## State management in Cycle.js

State management is well-known as one of the biggest challenges in web development. There are tens of libraries which try to simplify state handling and help creating high quality web applications easily. Two of my favorite libraries (for React) are: [MobX](https://github.com/mobxjs/mobx) and probably the most popular one, [Redux](https://redux.js.org/).

However, In my experience, setting up Redux might feel quite confusing and the code verbose and full of boiler-plate.

In Cycle.js, the [almost official](https://github.com/cyclejs/cyclejs/issues/620) state management solution is called [cycle-onionify](https://github.com/staltz/cycle-onionify). , I'm also using it in my application for state handling.

TODO: Write more about onionify, lenses etc.

Note: In this blog post, I will not try to compare Redux, MobX and cycle-onionify. That might end up in another blog post at an undefined time.

## Testing Cycle.js applications

Testing Cycle.js application is quite easy, since most of your functions are pure functions. Testing a pure function is easy since you know nothing outside of the function affects the output of the function and the function does not affect the outside world.

In testing Meeting Price Calculator specifically, it has been proven useful that in Cycle.js, time is just a dependency and you can inject or pass that to your functions. This makes testing a lot simpler.

TODO: Write more about testing, property based testing and the available helpers etc.

## Meeting Price Calculator

In March 2017, I wanted to learn Cycle.js and started literally by "building something" as you can see from the first commit message in the below screenshot.

![Start building something]({{ "/images/02-frp-cyclejs/first-commit.png" | absolute_url }})

The current functionality and look of the application is best described by visiting [the site](https://mpc.olpe.fi/) or by the gif below.

![Meeting Price Calculator GIF]({{ "/images/02-frp-cyclejs/meeting-price-calculator.gif" | absolute_url }})

The idea for the application came from my personal frustration in long meetings at work. Sometimes meetings are useful and worth the cost, but most of the meetings are too long and ineffective or just useless. The idea is to have this calculator on a big screen during a meeting to make everyone more effective and aware of the real cost of multiple persons sitting in a room and discussing. I haven't actually dared to do that during a real meeting yet.

## Recap

Key take aways

TODO: Write these

## Supporting Cycle.js

In addition to the community members, Cycle.js is maintained by the core team members. The project is funded by [Open Collective contributions](https://opencollective.com/cyclejs#contributors).

You can also support Cycle.js.

## Acknowledgements

- Thanks to my employer [Futurice](https://futurice.com/) for sponsoring open source development through [Spice Program](https://spiceprogram.org/oss-sponsorship/)
- Thanks to [Andre Staltz](https://staltz.com/) for reviewing my code and  helping me simplify the state handling in my app
- Thanks to the awesome Cycle.js community members who are always willing to help when needed

