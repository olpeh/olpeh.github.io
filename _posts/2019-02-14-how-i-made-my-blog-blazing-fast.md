---
title: 'How I made my blog blazing fast'
date: 2019-02-14 00:00:00 Z
layout: post
excerpt: 'Have you noticed how fast my website loads? In this blog post I will explain what usually slows down web pages and how I was able to improve the performance of my website.'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
image: '/images/08-blazing-fast/bonfire.jpg'
altText: 'Sparks coming from a bonfire, taken with a long exposure time.'
---

## 4 x 100

[![4 times 100 in the lighthouse audit.]({{ "/images/08-blazing-fast/100.png" | prepend: site.baseurl }})]({{ "/images/08-blazing-fast/100.png" | prepend: site.baseurl }}){:target="\_blank"}

Isn't this a beautiful sight.
This screenshot is from the [Lighthouse](https://developers.google.com/web/tools/lighthouse/){:target="\_blank"}{:rel="noopener"} audit result for my webpage.

Lighthouse is an amazing tool for _quickly_ auditing the performance of a website.
It may give you useful hints when trying to find the performance bottlenecks in loading a webpage.
However, the results are not absolute and they should be taken with a grain of salt.
But, I think everyone agrees seeing 4 times 100/100 feels good.
And, as the most important measurement of performance, my site feels fast to use even on mobile devices and slower connections.

## How Browsers Render Webpages

In order to understand what typically slows down a website loading performance, we need to understand the basics of what happens when you navigate to a website using a web browser.
The following explanation will be a simplified version in order to keep the blog post short.
Additionally, I do not understand everything that happens in between navigating to a URL and a fully loaded and rendered web page showing on the screen.

### The Client-server Architecture of the Web

[![The client-server architecture of the web.]({{ "/images/08-blazing-fast/client-server.png" | prepend: site.baseurl }})]({{ "/images/08-blazing-fast/client-server.png" | prepend: site.baseurl }}){:target="\_blank"}

The above figure shows a simplified version of what happens when a user accesses a traditional server rendered webpage.
Only a successful case is covered in this example.

First the user opens a web browser and types in the address or clicks a link on a webpage.
The browser will do a DNS lookup for the address in order to find the server's IP address.
The browser will then send a HTTP GET request to the server, which the address points to.
The server will return the HTML file for that webpage.
When the browser receives the response, it starts parsing it and may notice resources that need to be downloaded, such as `styles.css` and `main.js` in the above example.
The browser will then send HTTP requests for those resources and stop everything else while waiting for the results.
Finally, as early as possible, the webpage content will be rendered on the user’s screen.

### Critical Rendering Path

The above mentioned render-blocking steps before rendering a webpage are commonly referred to as the [Critical Rendering Path](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/){:target="\_blank"}{:rel="noopener"}.
It consists of the steps required before the browser is able to display the contents of the webpage on your screen.

Simplified version includes these steps:

- DNS lookup
- Connecting to the server
- TCP connection establishment
- TLS handshake
- Sending the request
- Receiving the HTML document
- Parsing the response
- Starting to render
- Further render-blocking requests
- Executing render-blocking JS
- Applying styles
- Continue rendering

As you can understand, there are a lot of steps required in order to render a webpage.
Browser vendors are doing a great job in optimizing the rendering.
Pre-lookahead parser quickly scans the document for external resources, and tries to fire the most important requests with high priority.
Additionally, developers are able to give priority hints to the browser in order to help it prioritize critical resources for improved loading performance.

However, most of the time, developers can also do more by reducing the amount and the duration of the required steps in the Critical Rendering Path.

### Common Causes of Slow Webpages

Here is a list of the most common causes for slow webpages:

- Render blocking resources:
  - CSS
  - (web) fonts
  - JavaScript
- Analytics
- Ads
- Huge asset sizes
- Oversized and unoptimized images
- No CDN used
- Ineffective caching
- Slow backends

The list is not complete, and not a scientific result, but rather how I feel about the topic.
But as you can see, I put the slow backends as last on the list.
In my experience backend is typically not the bottleneck, but rather the frontend is.

## Why My Webpage is Blazing Fast

These simple steps:

- The site is fairly simple and small
- No analytics, ads or tracking, in fact
- Inline critical CSS
- Optimize images
- Prefetch pages that the user is likely to visit next

The results of these optimizations can be in the screenshot below.

[![Screenshot of the lighthouse audit results for my page.]({{ "/images/08-blazing-fast/lighthouse.png" | prepend: site.baseurl }})]({{ "/images/08-blazing-fast/lighthouse.png" | prepend: site.baseurl }}){:target="\_blank"}

## Final Words

Remember, that performance is all about the user experience. You users don’t care what framework you use for building your fancy website. They don’t care whether you use HTML + CSS + JS or CSS-IN-JS or whatever JS-JS-JS solutions. The only thing your average users care about is the actual perceived performance and usability of the end result.

Figuring out the perceived performance is not a simple task and can not be automated. In order to get useful results, you may need to actually reach out to your users and interview them and see how they experience your site or your application.

## Learn More

If you are interested in learning more about web performance, I have collected a list of links to useful resources on this topic.
You can find [the list in this repository on GitHub](https://github.com/olpeh/notes-and-lists/blob/master/web-dev-interesting-links.md#web-performance){:target="\_blank"}{:rel="noopener"}.
