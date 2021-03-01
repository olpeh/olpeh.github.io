---
title: 'JavaScript Should Be Your Last Resort'
date: 2021-03-02 12:00:00 Z
layout: post
excerpt: 'Client side JavaScript is the single biggest reason for slow websites. It should be avoided and only used cautiously if nothing else works.'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
tags: performance HTML CSS JS
image: '/images/20-js/hammer.jpg'
altText: 'Photo of a hammer about to hit some nails.'
credits: 'Photo by Fausto Marqués on Unsplash'
---

## JS Is Your Hammer

When working on modern frontend web development, using your favorite framework of choice, it can be sometimes tempting to solve all the problems with JavaScript. Sometimes this happens unconsciously as JS is what you mostly use in your day-to-day development work.

This is similar to the situation described by Abraham Maslow in 1966:

> I suppose it is tempting, if the only tool you have is a hammer, to treat everything as if it were a nail.
>
> – [Wikipedia: Law of the instrument](https://en.wikipedia.org/wiki/Law_of_the_instrument){:target="\_blank"}{:rel="noopener noreferrer"}

**Note:** In this blog post, I'm only talking about JS even though I'm mostly using TS at my projects – it ends up as JS after compilation any ways.

### What to Take into Account When Implementing UI

This mindset of using JS for everything causes unnecessary processing that needs to be run on your end users' devices as unnecessary client side JS, that needs to be downloaded, parsed and executed. This is quite often the cause of slow and unresponsive websites on low-end mobile devices or slow network speeds.

#### How you should be thinking instead:

1. Can this be done in HTML?
1. If not, can I solve it with HTML + CSS?
1. And if nothing else works, the solution probably requires a minimal amount of JS in addition to HTML and CSS

This way of thinking is not about what is easiest for you as a developer. You may be a JavaScript focused frontend developer, and solving most of your problems with it feels natural for you. However, you should be thinking about your end users. Client side JS is the single biggest problem when it comes to web performance. You can read some of my thoughts on web performance from my other blog posts. Links at the end of this post.

### 1. Can This Be Done in HTML?

Plan and implement the basic structure and semantics of the feature in plain HTML without any extra styles and using native HTML elements and functionality. If some additional styling or features are needed, go to step 2.

### 2. Try to Solve It with HTML + CSS

Use CSS to apply the additional styling that is required, still keeping the semantics and accessibility in my mind. If some additional interactivity is required in the particular piece of UI you are building, go to step 3.

### 3. Use HTML + CSS + JS

Add the minimum amount of JS required to fulfill the requirements. Keep in mind that something that can be solved without JS should probably be solved without JS.

When you’re done, show your code to your colleagues and let them review it. Perhaps there is still something unnecessary parts in your code, that could be solved without having a client side JS cost on your users.

## Silly Example

This problem applies to almost anything in web frontend development, but here is a silly practical example to prove my point. Imagine you are working on a React project, and you would be working on a feature that has some UI parts that would only be visible after a certain delay, let's say after 2s.

### Using React Hooks

If you are used to solving your problems with React, using React Hooks, your initial solution could look something like this:

```tsx
const [thingVisible, setThingVisible] = useState(false);

useEffect(() => {
  const timeoutId = setTimeout(() => {
    setThingVisible(true);
  }, 2000);

  return function cleanup() {
    clearTimeout(timeoutId);
  };
}, []);

return thingVisible ? <section>Here's a thing for you!</section> : null;
```

This is fine and works. Probably you notice no difference in performance either on your ultra powerful developer machine. And probably there is no real performance issue in this case. But imagine if these pile up and suddenly you would have tens or hundreds of similar unnecessary JS computations to be run on the client side.

### Using HTML + CSS Animation

However, you can animate content to appear on the page with a delay using CSS animations and `animation-delay`. This is supported by all browsers and could even have a better end user experience as you could fade the content in or use any other ways of making the content appear more smoothly.

```html
<section class="fade-in">Here's a thing for you!</section>
```

```css
.fade-in {
  opacity: 0;
  animation: fadeIn 2s;
  animation-delay: 2s;
  animation-fill-mode: forwards;
}
@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
```

## Don’t use CSS for what you can do with HTML

Similarly, don’t do something with CSS that you could and should be doing in HTML.

An extreme example of this was that we had accidentally been using margins to separate two words from each others, instead of using a space in between words!

This was obviously not a good idea from at least the following perspectives:

- It might not follow the font size, letter spacing etc.
- It is not needed, waste of effort and processing

## Frontend Development Is Not Easy

Web frontend development is not an easy topic to master. It requires some experience and understanding the whole picture in order to be able to solve the right problems on the right level using the right tools. Solving something on the frontend has many levels and details baked in.

Additionally, you'll need to understand when a problem should be solved on the backend instead of on the frontend for various reasons such as performance and usability.

However, keep in mind that sometimes you don't need to try to reach for a perfect solution and something that works might be good enough to be shipped to production and to be used by your end users.
