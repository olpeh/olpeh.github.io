---
title: 'We have gone full circle'
date: 2019-11-14 00:00:00 Z
layout: post
excerpt: 'Why is Server Side Rendering highly relevant in the golden age of JavaScript Single Page Applications?'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
image: '/images/10-slack-bot/slack.png'
altText: 'Slack logo'
---

## How the Web Looks Like in 2019

The web as we know it, consists of web pages and applications built with a variety of technologies.
However, there is onne thing all web pages have in common, and that is HyperText Markup Language (HTML).
All technologies that create some visible content in the end produce more or less HTML that then gets painted on the screen by the web browser.
Most of the web pages also use Cascading Style Sheets (CSS) for styling and JavaScript (JS) for dynamic functionality.
More and more modern web pages are built as JS Single Page Applications (SPA) that rely heavily on the JS runtime for rendering content on the screen.
This does not necessarily mean writing all the code as JS, but compile-to-js languages and tools are available and most commonly known is TypeScript (TS).

In the end all of the web technologies end up creating the webpage content as HTML that gets rendered on the screen.
There is however, huge variations in the page "weights" as in how heavy and low performing the different web pages are.
Performance is directly connected with how likely your users are to return to your web page and if you are selling something, bad performance will directly affect your sales.

Sadly the situation does not seem to get better even though one could thing that the evolution of technology and tools would make the web a better place for everyone, and most importantly on the increasing amount of mobile devices that are used.
In fact, based on HTTPArchive (citation needed!), the amount of web traffic from mobile and tablet devices surpassed the traffic from desktop devices already in 2016 globally.
Based on the HTTPArchive stats, web pages got ~20% heavier and slower on almost all metrics when comparing 2017 to 2018.
TODO: Cost of JS in 2019 https://v8.dev/blog/cost-of-javascript-2019

### Definitions First

Let's look at some of the commonly used terms and their definitions before we dive deeper into the main topic of this blog post.

## Server Side Rendering

In a Server Side Rendered (SSR) web page, the web server returns an HTML document that already contains the content as HTML.
The browser will then render the document contents on the screen whenever it receives the document and parses it from top to bottom.

## Client Side Rendering

Client Side Rendering on the other hand refers to a technique where the server only returns a skeleton of the application in the HTML document.

## Isomorphic Rendering

Isomorphic Rendering refers to a technique where both SSR and CSR are combined in a web application.
The server renders the document content and the application state into HTML.
After rendering the SSR content on the screen and loading the JavaScript bundle, the JS application then reads the initial state from the server rendered response and boots up the JS application.
This is called rehydration, the static server rendered HTML document gets hydrated into a JavaScript SPA.

## A Simplified History of the Web

The web was invented for about 30 years ago.
In the beginning everything was fully server side rendered web pages.

## AMP

## 5 reasons why SSR is highly relevant in 2019

### 1. Performance

### 2. SEO

### 3. Accessibility

### 4. Not Everything Needs to be an App
