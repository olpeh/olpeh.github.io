---
title: I Learned Functional Reactive Programming by Learning Cycle.js
date: 2018-03-10 00:00:00 Z
layout: post
excerpt: "An introduction to Cycle.js and a story of what I learned while building Meeting Price Calculator"
author: "Olavi Haapala"
thumbnail: "/images/02-frp-cyclejs/cyclejs.svg"
---

In this post, I will write about my experiences in learning Functional Reactive Programming (FRP) by writing an application in Cycle.js. First I'll try to explain the basics of Cycle.js and FRP. Later on in the blog post I will write about my learnings while building [Meeting Price Calculator](https://mpc.olpe.fi/) using Cycle.js. When I started learning Cycle.js, I did not know what Reactive Programming was and I had not been doing any Functional Programming either.

<img src="{{ "/images/02-frp-cyclejs/cyclejs.svg" | absolute_url }}" width="120" aria-hidden="true">

## What is Cycle.js?
If you know what Cycle.js is, you can easily skip this chapter.

You might not have heard about Cycle.js since it is not as popular as React or Vue or others.
However, it's a proper and mature JS Framework, which is used in production by several projects.

`"Oh yeah, yet another JS Framework"` – you might think.

That's not the case with Cycle.js. It's different. It's not like any other framework out there. Let's see what the official documentation describes it like:

>A functional and reactive JavaScript framework for predictable code

Source: [cycle.js.org](http://cycle.js.org/)


In order to understand what that means, we have to be able to understand and define three things:

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

If the ES6 arrow function syntax is unfamiliar to you, the firs one means a a funtion that takes no parameters and after the arrow (`=>`) is the function body. In the second example, the function takes one parameter and returns that parameter incremented. Curly braces or return statement are not needed

The main difference here is that the first example mutates a global variable as opposed to the second example, which takes a variable called `counter` and returns a new variable that is the `counter` incremented by 1.

FP is of course a lot more than this, but for now understanding the basic ideology is enough. Learning functional programming will help you write code that is easy to test and maintain. Testing a pure function is easy, since you don't need to mock anything. Just give the inputs and check if the output is as expected.

### What is Reactive Programming (RP)?

Reactive Programming is a programming paradigm that is based on using asynchronous streams.

### What is FRP then?

FRP is simply a combination of both functional and reactive paradigms. Cycle.js is a nice example of combining these two.

### Predictable code?

It's probably a bit controversial and subjective to say that some code is predictable and something is not. However, using FRP paradigms concistently may result in easily testable and predictable code. This is the case with Cycle.js. You can see the whole interaction and data flow by reading the code, without having to think about global state or event listeners defined in another file etc. In reactive code, you can see the interactions happening in because you control how to react to different events and not the other way round like in imperative programming.

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

## State management in Cycle.js

State management is well known to be one of the biggest challenges in web development. There are tens of libraries which try to simplify state handling and help creating high quality web applications easily. Two of my favorite libraries (for React) are: [MobX](https://github.com/mobxjs/mobx) and probably the most popular one, [Redux](https://redux.js.org/).

However, I think setting up Redux can be quite confusing and the code full of boiler-plate and verbose.

In Cycle.js, the [almost official](https://github.com/cyclejs/cyclejs/issues/620) state management solution, that I'm also using is called [cycle-onionify](https://github.com/staltz/cycle-onionify).

Note: In this blog post, I will not try to compare Redux, MobX and cycle-onionify. That might end up in another blog post at an undefined point in time.

## Testing Cycle.js applications

Testing Cycle.js application is quite easy, since most of your functions are pure functions. Testing a pure function is easy since you know nothing outside of the function affects the output of the function and the function does not affect the outside world.

In testing Meeting Price Calculator specifically, it has been proven useful that in Cycle.js, time is just a dependency and you can inject or pass that to your functions. This makes testing a lot simpler.

## Meeting Price Calculator

In March 2017, I wanted to learn Cycle.js and started literally by "building something" as you can see from the first commit message in the below screenshot.

![Start building something]({{ "/images/02-frp-cyclejs/first-commit.png" | absolute_url }})

The current functionality and look of the application is best described by visiting [the site](https://mpc.olpe.fi/) or by the gif below.

![Meeting Price Calculator GIF]({{ "/images/02-frp-cyclejs/meeting-price-calculator.gif" | absolute_url }})

The idea for the application came from my personal frustration in long meetings at work. Sometimes meetings are useful and worth the cost, but most of the meetings are too long and ineffective or just useless. The idea is to have this calculator on a big screen during a meeting in order to make everyone more effective and aware of the actual cost of multiple persons sitting in a room and discussing. I haven't actually dared to do that during a real meeting yet.

## Recap

Key take aways

## Supporting Cycle.js

In addition to the community members, Cycle.js is maintained by the core team members. The project is funded by [Open Collective contributions](https://opencollective.com/cyclejs#contributors).

You can also support Cycle.js.

## Acknowledgements

- Thanks to my employer [Futurice](https://futurice.com/) for sponsoring open source development through [Spice Program](https://spiceprogram.org/oss-sponsorship/)
- Thanks to [Andre Staltz](https://staltz.com/) for reviewing my code and  helping me simplify the state handling in my app
- Thanks to the awesome Cycle.js community members who are always willing to help when needed


