---
title: 'Modern and Accessible <marquee> Replacement with React and Tailwindcss'
date: 2021-02-23 12:00:00 Z
layout: post
excerpt: '<marquee> is deprecated and should not be used, but sometimes you need similar functionality even in modern web development.'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
tags: marquee CSS A11Y
---

## Fun Fact

Even though `<marquee>` is deprecated, it's really not gone, the functionality is currently available in most web browsers but it's not recommended to use it as it can be removed any time in the future without a warning. [See the MDN page for `<marquee>` for more details](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/marquee){:target="\_blank"}{:rel="noopener noreferrer"}.

When I started drafting this blog post and used `<marquee>` in the `title` and `excerpt` of this post, the page contents started scrolling to left and I had to fix this by escaping the `title` and `excerpt` before rendering them as HTML.

![My webpage contents started scrolling, due to `<marquee>` in content]({{ "/images/19-marquee/marquee.gif" | prepend: site.baseurl }})

So, remember to escape your content, especially if it's input directly from your users.

## What Is `<marquee>`

As you could see from the above GIF, `<marquee>` is/was a HTML element that scrolls its contents.

<marquee>
Here's an example for you, that should render this text as an element with scrolling text if your browser still supports these.
</marquee>

## Problems with Marquee

1. Not very user friendly.

1. Not very modern.

1. Stressful for the user who might miss some of the content and has to wait for the scrolling to start from the beginning.

1. Not respecting user's preference for reduced motion. Many people will feel sick when a website has moving elements on it.
