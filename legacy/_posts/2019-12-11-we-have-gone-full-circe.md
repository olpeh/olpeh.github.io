---
title: 'Server Side Rendering: Why We Have Gone Full Circle'
date: 2019-12-11 06:40:00 Z
updated: 2019-12-11 15:35:00 Z
layout: post
excerpt: 'Why is Server Side Rendering highly relevant again in the golden age of Single Page Applications?'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
image: '/images/11-ssr/thomas-lambert-unsplash.jpg'
altText: 'Aerial photo of a circle road in nature'
credits: 'Photo by Thomas Lambert on Unsplash'
---

### Author's notice

This blog post is based on one of my recent tech talks "Why is SSR relevant in 2019" and represents my limited view on the topic.
Please bare that in mind when reading this blog post.
My view on the history of the web may have mistakes and is certainly not covering all aspects.
In the beginning of this post I'm trying to explain some of the key concepts and how the web works before diving deeper into why Server Side Rendering is relevant today.

I almost got carried away and did not get into writing about the main topic until late in this post, so please feel free to jump over the first half of the post and start reading from [4 Reasons Why SSR is Highly Relevant Today](#4-reasons-why-ssr-is-highly-relevant-today).

This blog post is highly opinionated, read at your own risk!

<hr/>

## How the Web Looks Like Today

The web as we know it, consists of web pages and applications built with a huge variety of technologies.
However, there is one thing all web pages have in common, HyperText Markup Language (HTML).
In the end all of the web technologies end up creating the webpage content as HTML that gets rendered on the screen.
Most of the web pages also use Cascading Style Sheets (CSS) for styling and JavaScript (JS) for dynamic functionality.
More and more modern web pages are built as JS Single Page Applications (SPA) that rely heavily on the JS runtime for rendering content on the screen and handling the application logic and navigations.
This does not necessarily mean writing all the code as JS directly, but there are multiple compile-to-js languages and tools available.
Most commonly known is TypeScript (TS).

Even though all web pages are quite similar from technical point of view, there are huge variations in the page "weights" as in how heavy and slow performing the different web pages are.
Performance is directly connected with how likely your users are to return to your web page.
If you are running an e-commerce business, and trying to sell something, a bad performance will directly affect your sales.

Sadly the situation does not seem to get better over time even with the evolution of technology and web development tools.
One could easily assume better tools and tech would make the web a better place for everyone, and most importantly for the increasing amount of users browsing on mobile devices.

In fact, based on HTTP Archive, the amount of web traffic from mobile and tablet devices surpassed the traffic from desktop devices already in 2016 globally.
This can bee seen in the below image.

[![Global internet usage stats from 2009 to 2016.]({{ "/images/11-ssr/internet_usage_2009_2016_ww.png" | prepend: site.baseurl }})]({{ "/images/11-ssr/internet_usage_2009_2016_ww.png" | prepend: site.baseurl }}){:target="\_blank"}

Based on [the HTTP Archive stats](https://httparchive.org/reports/page-weight?start=2017_05_01&end=2018_05_15&view=list){:target="\_blank"}{:rel="noopener"}, web pages got ~20% heavier and slower on almost all metrics when comparing 2017 to 2018.
Most of the increase in page weight and slowness can be explained by the increasing amount of JS on web pages.
On the other hand, many web pages are a lot more complex nowadays than they used to (or need to!) be.

If you like to read more about heavy webpages and the biggest reason for slow webpages, go ahead and read [The Cost Of JavaScript In 2018](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4){:target="\_blank"}{:rel="noopener"} (sorry, Medium link!) and [The Cost of JS in 2019](https://v8.dev/blog/cost-of-javascript-2019){:target="\_blank"}{:rel="noopener"}.

## Some Definitions

Let's look at some of the commonly used terms and their definitions before diving deeper into the main topic of this blog post.

### Server Side Rendering

In a Server Side Rendered (SSR) web page, the web server returns an HTML document that already contains the content as HTML.
The browser will render the document contents on the screen whenever it receives the document and parses it from top to bottom.

### Client Side Rendering

Client Side Rendering on the other hand refers to a technique where the server only returns a skeleton of the application in the HTML document.
The HTML only acts as a template and has a link to the JS application bunldle, which the browser downloads, parses, and excecutes.
The JS application then renders the contents by hooking itself into a root div that is part of of the server rendered HTML contents.
Usually this means something like:

```html
<body>
  <div id="app"></div>
</body>
```

### Isomorphic Rendering

Isomorphic Rendering on the other hand, refers to a technique where both SSR and CSR are combined in a web application.
The server renders the document contents as well as the initial application state as JSON in the HTML.
After rendering the SSR content on the screen and loading the JavaScript bundle, the JS application then reads the initial state from the server rendered response and boots up the JS application.
This phase is called rehydration, the static server rendered HTML document gets hydrated into a JavaScript SPA.
This approach tries to achieve the best of both worlds by achieving a fast first paint because of SSR content and fast SPA navigations after the application has been rehydrated.

## A Short and Simplified History of the Web

The web was invented for about 30 years ago.
In the beginning everything was fully server side rendered web pages.
First web pages were documents containing text and links, images were added a bit later.
More and more interactivive elements were aded as part of the web when JavaScript invented.
Interactive elements suc as Flash, Quicktime, RealPlayer, and Shockwave came along.
Still, at this time most of the web pages were built using SSR with mostly PHP and friends.

### JS Fatique

A multitude JS libraries started popping up such as MooTools, jQuery, and Backbone.
These allowed developers to create interactive web applications more easily using JS instead of Flash or other old school tools.
Later on, Angular.js was published and in around 2014 React was published.
This started a new era in the web development scene.
Suddenly "everyone" was doing client side rendered JS based SPAs.
This caused web pages to get heavier and slower.
Something needed to be done.

Progressive Web Applicationss got introduced.
Along other features, they provided an additional cache layer on the client level using Service Workers.
However, in my opinion this is a wrong solution to the problem of slow web pages.

### Back to the Roots

Recently the web development community has started realizing that going full on with client side rendering was a mistake and ruined the web performance, especially on cheaper and slower devices.
Now, suddenly "everyone" is talking about SSR again and many frameworks and platforms provide solutions for that.
This is a good direction from web performance point of view.

## Accelerated Mobile Pages

Accelerated Mobile Pages (AMP) is Google's iniative for making the web faster on mobile devices.
I think the initiative in itself is good, but I don't like the way Google tries to enforce it and take the ownership of the web and its contents by serving pages from their own cache servers.
Google is also misusing its huge position in the market by prioritizing AMP pages in Google search results.
Sadly most of the people are using Google for searching, which forces companies to start considering using AMP in order to achieve good positions in search results.
Due to the above mentioned reasons, I would not recommend supporting or using AMP at all.

AMP in itself is a good library for creating web pages, because it limits the possibilities in which you are able to create horrible user experiences on the web.

Even AMP recently announced a revolutionary new technology called SSR in the AMP library as you can see in the below screenshot of Ricky Mondello's sarcastic tweet:

[![Screenshot of Ricky Mondello's tweet: https://twitter.com/rmondello/status/1160201903566802949]({{ "/images/11-ssr/rmondello.png" | prepend: site.baseurl }})](https://twitter.com/rmondello/status/1160201903566802949){:target="\_blank"}{:rel="noopener"}

I agree with Ricky, that this is ridiculous.
We have had HTML and SSR for 30 years, what do we need AMP for?

Okay, time to move to the _actual_ topic of this blog post.

<hr />

## 4 Reasons Why SSR is Highly Relevant Today

Here are my 4 reasons for using SSR today.

### 1. Performance

Web pages that are rendered only on the client side tend to have quite slow time to First Paint (FP) and First Meaningful Paint (FMP), because the browser has to first download, parse, and excecute the JS bundle before it can paint the contents on the screen.
The below screenshot tries to visualize what these different metrics means.

[![Timeline that explains the different performance metrics.]({{ "/images/11-ssr/perf-metrics-load-timeline.png" | prepend: site.baseurl }})]({{ "/images/11-ssr/perf-metrics-load-timeline.png" | prepend: site.baseurl }}){:target="\_blank"}

Image source: [User-centric Performance Metrics](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics){:target="\_blank"}{:rel="noopener"}.

In order to achieve a good user experience, try to move these events as close to the left as possible, meaning as fast after navigation start as possible.
Additionally Time To Interactive (TTI) is an important metric, because before that moment in time, your users can't start interacting with the interactive parts of your site.

This is where SSR has its biggest win.
With server rendered pages, the browser is able to paint the document contents on the screen immediately when it has received the document and goes through the contents of it.
With this approach, it is possible to achieve

### 2. Search Engine Optimization (SEO)

Google and other search engines most probably will not run the JS on your web page when indexing the web.
There are rumours that Google is running the JS, but with a 2 weeks delay.
For most of the businesses where a good SEO is critical, a 2 weeks delay is not acceptable.
~~And as a cherry on top, Google reportedly runs your JS with an ancient version of Chrome, which is even worse than IE9.~~ _Edit_: This was not true anymore, [Google bot now uses the latest version of Chromium](https://searchengineland.com/google-will-ensure-googlebot-runs-the-latest-version-of-chromium-316534){:target="\_blank"}{:rel="noopener"}.

So, if you care about good SEO, use SSR.
However, if you have a fully functional SPA and don't want to invest time in implementing SSR, there are ready made services that does the SSR for you.
At least Netlify has SSR as a service that you can start using if you are hosting in Netlify.

### 3. Accessibility

Accessibility is about making it possible for _everyone_ to access and understand the contents on your webpage.
Accessibility is about performance as well.
A slow webpage is not accessible to everyone, only those on high-end devices and fast network connection speeds.

Some people even prefer to browse the web without having JS enabled.
If you SSR your main content, your web page will be accessible even withou JS enabled.
If your application uses SPA navigations when the user clicks on links, don't worry, they will work fine as normal links that have been working for 30 years already without JS.

### 4. Not Everything Needs to be an App

Remember, that even though creating web applications is popular, not everything nees to be an application.
In many cases, a simple HTML based SSR web page is enough.
Say, a landing page for a newly started company.
You don't need to build it as a SPA application, especially if you build it as a one-pager with navigations happening in that same page.
There's a revolutionary technology for achieving just that, and it's called anchor tags or `<a>`.
So, please use the platform #usetheplatform.

## Final Words

No matter, what technology you use, remember to consider your real end users over a better Developer Experience (DX).
In the end, the only thing that matters is that your users are happy.
In most of the cases that means having a fast experience even on mobile devices and flaky connections.
By optimizing your web application or web page for slower devices and slower networks speeds, you will end up making it a better experience to everyone.
Similarly, by focusing on making your application accessible, you will end up making it more usable to everyone.
