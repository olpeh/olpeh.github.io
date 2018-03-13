---
title: I Learned Functional Reactive Programming by Learning Cycle.js
date: 2018-03-11 00:00:00 Z
layout: post
excerpt: "An introduction to Cycle.js and a story of what I learned building Meeting Price Calculator in Cycle.js"
author: "Olavi Haapala"
author_twitter: "0lpeh"
thumbnail: "/images/02-frp-cyclejs/cyclejs.svg"
---

In this blog post, I will be writing about my experiences learning Functional Reactive Programming (FRP) by writing an application in Cycle.js. First I will try to explain the basics of Cycle.js and FRP. Later on in the blog post, I will write about my learnings while building [Meeting Price Calculator](https://mpc.olpe.fi/) in Cycle.js. When I started learning Cycle.js, I did not know what Reactive Programming was and I had not done almost any Functional Programming either.

<img src="{{ "/images/02-frp-cyclejs/cyclejs.svg" | absolute_url }}" width="120" aria-hidden="true">

## Background

You might not have heard about Cycle.js, since it is not as popular as React or Vue or others.
However, it's a proper and mature JS Framework used in production by several projects.

`"Oh yeah, yet another JS Framework"` – you might think.

That's not the case with Cycle.js. It's different. It's not like any other framework out there. Later in this post, I'll try to explain Cycle.js and why it's different.

I first heard about Cycle.js in 2015 when I started as a summer employee at [Futurice](https://futurice.com). [Andre Staltz](https://staltz.com/about.html), the creator of Cycle.js, used to work at Futurice as well and was demoing it in a WWWeeklies presentation. I got interested in it and tried it out for a bit. Later that summer I was also part of an internal project where we started using Cycle.js. However, it was not before March 2017 that I really started building something with Cycle.js. More about that later in this post.

I'm no expert in Cycle.js or FRP, but I'll try to explain things as I understand them and how I learned them. If you have any feedback on the content of this blog post, I'll gladly hear about that.

So, back to what Cycle.js is. Let's see what the official documentation describes it like:

>"A functional and reactive JavaScript framework for predictable code" <br/>
> – From [cycle.js.org](http://cycle.js.org/)


In order to understand what that means, we have to understand the following three concepts:

1. Functional Programming (FP)
1. Reactive Programming (RP)
1. Predictable code

I will do my best in trying to explain what these mean in a simple and understandable way.

### What is Functional Programming (FP)?

Functional Programming is a popular programming paradigm where the main idea is to avoid using global state, mutable data or side effects. In FP, data flows through `pure functions`, meaning that the function has no side effects. Side effects in this context means changing something outside the function scope, like changing a global variable or sending a HTTP request.

A super simple example of a function that does *not* follow the functional paradigm:

```JS
let counter = 0
const incrementCounter = () => counter += 1;
```

The same function as a pure function that has no side effects:

```JS
const incrementCounter = counter => counter + 1;
```

If the ES6 arrow function syntax is unfamiliar to you, the firs one means a function that takes no parameters and after the arrow (`=>`) is the function body. In the second example, the function takes one parameter and returns that parameter incremented. Curly braces or return statement are not needed for single-line function bodies.

The main difference here is that the first example mutates a global variable as opposed to the second example, which takes a variable called `counter` and returns a new variable that is the `counter` incremented by 1.

FP is of course a lot more than this and I'm no hard-core-FP-enthusiast, but for now understanding the basic ideology is enough. Learning functional programming will help you write code that is easy to test and maintain. Testing a pure function is easy, since you don't need to mock anything. Just pass the inputs and check if the outputs are as expected. More about testing Cycle.js applications later in this blog post.

### What is Reactive Programming (RP)?

Reactive Programming is a programming paradigm based on asynchronous events streams, meaning sequences of events happening over time. If the concept of streams is unfamiliar to you, you can think of streams as an array that will receive values over time. An example stream could be a click stream, which will receive events when the user clicks something on a page. In your code you can then decide how to react to those events happening over time. Streams have a start and they may also have an end. In Cycle.js these event streams are referred to as `Observables`.

A good example of reactivity is using formulas in Excel spreadsheets. The visible values are immediately reacting to the changes in the data. You don't have to call any update functions to update the calculations, but the cells react to changes in the data.

In RP, modules are responsible for reacting to changes and not responsible for changing other modules like in traditional, so-called passive programming. This is visualized in the image below where `Bar` is reacting to a event happening in `Foo` instead of `Foo` poking `Bar` for a change.

![Reactive Foo and Bar visualization]({{ "/images/02-frp-cyclejs/reactive-foo-bar.svg" | absolute_url }})
Source: [Cycle.js documentation](https://cycle.js.org/getting-started.html)

This is why In RP, understanding how a module works is a lot easier than in passive programming. You only need to look at the code for that module, and not all over the codebase. All of its future is defined there. No remote modules will change it. The only changes happening are declared in the module and these changes can be based on events emitted by other modules.

The opposite of RP, passive programming is when the change to a module is defined somewhere else. This causes the module to have public methods, like say `updateTotalCount` or similar that are then called by other modules when something happens.

I have been there, struggling with looking for who's responsible for sending emails after a successful payment in an E-comerce plaftorm. In the end I found out that the payment module was handling the email sending after receiving a successful payment. What would have happened if the payment module was replaced with something else? Who would have thought that the payment module was actually responsible for sending the emails as well?

> "Whenever the module being changed is responsible for defining that change." <br/>
– *Andre Staltz* about the definition of Reactive Programming

There is a lot more to RP than what I am able explain in a blog post. Take a look at [Cycle.js documentation about RP](https://cycle.js.org/streams.html#streams-reactive-programming), if you want to learn more. On a side-note, the documentations for Cycle.js are well formulated and kept up-to-date.

### What is FRP then?

FRP simply combines both functional and reactive paradigms, picking the best of both worlds. Cycle.js is a nice example of combining these two.

### Predictable code?

In order to say that Cycle.js code is predictable we need to understand what predictable and unpredictable code means.

Having your code full of global variables and impure functions results in unpredictable code. You can never be sure what the output of a function is if it depends on some global state or global variable or has some side effects.

In other words predictable code means writing code that you can reason about. Functions that are pure will always have the same output with a given input, no matter how many times they are called or how the stars are aligned at the time execution. This is the case with Cycle.js. You can see the interaction and data flow by reading the code, without having to think about global state or event listeners defined somewhere else. In reactive code, you can see the interactions happening in the module's code because the module is in control of how to react to different events and not the other way round like in passive programming.

Predictability comes from moving side effects away from your modules and only having pure functions. This way you can predict what the result will be when you call a function in your code. Global variables or global state do not affect the result of a function, only the inputs affect the output of a function.

Of course, in the end it's up to you how organized and predictable code you write. One of the best things about Cycle.js code is that it's basically just TypeScript (or JS), but on the other hand, that's also the worst part of it as you might know if you have used JS/TS for a while. There is no strict language level enforcement for good practices or protection against runtime crashes.

## What is Cycle.js and why is it different?

So, now that we have the required background knowledge, let's focus into explaining what Cycle.js is and how it differs from the other frameworks out there.

In Cycle.js, the side effects and the application logic are separated. The logic part is purely functional and reactive code without side effects. This logic part can be thought of as a `main()` function in your Cycle.js app. The function is pure, it only receives `sources` as inputs and returns `sinks` as outputs. It does not do any side effects. `Sources` are the inputs to an Cycle app. They can be reads from the DOM, or HTTP responses for example. The `sinks` returned by the `main` function can be the writes happening to the DOM, or the HTTP request to be sent.

Side effects happen in the so-called `drivers`.

![Main - DOM - Side effects]({{ "/images/02-frp-cyclejs/main-domdriver-side-effects.svg" | absolute_url }})
Source: [Cycle.js documentation](https://cycle.js.org/getting-started.html)

TODO: Write about the basics of Cycle.js

![Nested component model in Cycle.js]({{ "/images/02-frp-cyclejs/nested-components.svg" | absolute_url }})
Source: [Cycle.js documentation](https://cycle.js.org/getting-started.html)

### How does it look like?

Now you might be wondering, how does Cycle.js code look like.

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

In Cycle.js, the [soon official](https://github.com/cyclejs/cyclejs/issues/620) state management solution is called [cycle-onionify](https://github.com/staltz/cycle-onionify). , I'm also using it in my application for state handling.

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

## Interested in learning more? Check out these resources

- [PolyConf 16 / Dynamics of change: why reactivity matters/ Andre Staltz](https://www.youtube.com/watch?v=v68ppDlvHqs)
- [The introduction to Reactive Programming you've been missing](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754)

## Acknowledgements

- Thanks to my employer [Futurice](https://futurice.com/) for sponsoring open source development through [Spice Program](https://spiceprogram.org/oss-sponsorship/)
- Thanks to [Andre Staltz](https://staltz.com/) for reviewing my code and  helping me simplify the state handling in my app
- Thanks to the awesome Cycle.js community members who are always willing to help when needed
- Thanks to [Andre Staltz](https://staltz.com/) for reviewing this blog post and suggesting improvements to it


