---
title: 'Modern and Accessible <marquee> Replacement with React and Tailwindcss'
date: 2021-02-23 12:00:00 Z
layout: post
excerpt: '<marquee> is deprecated and should not be used, but sometimes you need similar functionality even in modern web development.'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
tags: marquee CSS animations A11Y
---

## What Even Is/Was marquee?

Marquee is a deprecated HTML element that renders scrolling content. For more information, check [the MDN page for marquee for more details](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/marquee){:target="\_blank"}{:rel="noopener noreferrer"}.

It is not recommended to use the `<marquee>` element even though it might still work and additionally in modern days, you rarely need anything like this. However, sometimes you do and you might need a solution to this using modern web technologies.

Example `<marquee>` if your browsers still supports it:
<marquee>
Here's an example for you, that should render this text as an element with scrolling text if your browser still supports these.
</marquee>

## Problems with Marquee

1. Not very user friendly – many people do not like scrolling text.

1. Deprecated and not matching the modern web design.

1. Stressful for the user who might miss some of the content and has to wait for the scrolling to start from the beginning.

1. Not respecting user's preference for reduced motion. Many people will feel physically ill or sick when a website has (too many) moving elements on it.

## DO NOT USE JS FOR THIS

When implementing a `<marquee>`-like element using modern technologies, please bare in mind that you (probably) won’t need JS for the job outside of maybe using something like React to render the element.

My example implementation is using React in a Next.js project, but I chose not to use JS to achieve the wanted result. It is often better to try to achieve as much as possible without CSS whenever feasible. JS is the root of all performance issues and especially when used for something that can be achieved using HTML and CSS only. I will probably write another blog post about this topic at a later point in time.

## Marquee Using CSS Only

To achieve a rolling text effect, the only thing we need is some HTML and CSS. The effect can be achieved with CSS animations.

### Basic Solution With HTML + CSS

In order to animate the text and get the feeling that the text “wraps around” and goes on infinitely, we need to add the elements twice to the DOM and animate them starting from different positions. First element will start from `0` and go all the way to `-100%` and the other one will start from `100%` and go to `0`. If we animate both elements with the same duration, the first element will be reset back to the initial position when the second element reaches 0, thus the user won’t notice when the animation starts over again.

Here is a basic example snippet to achieve a `<marquee>` like effect using HTML and CSS.

HTML:

```html

```

CSS:

```css

```

And here's a link to a codepen with the above content and a functioning version of it:

[Codepen.io]()

### Using TailwindCSS

Tailwind config here:

```js
extend: {
    animation: {
        marquee: 'marquee 30s linear infinite',
        marquee2: 'marquee2 30s linear infinite'
    },
    keyframes: {
        marquee: {
            '0%': { transform: 'translateX(0%)' },
            '100%': { transform: 'translateX(-100%)' }
        },
        marquee2: {
            '0%': { transform: 'translateX(100%)' },
            '100%': { transform: 'translateX(0%)' }
        }
    }
}
```

And now we can use these animations using the classes that Tailwind generates for use:

```html

```

And here's a link to a codepen with the above content and a functioning version of it.

## Accessibility Aspects

Having animations and motion on a webpage can make some people feel physically ill or sick. That's why it is important that we as developers provide the users a way to opt-in to reduced motion. Many operating systems provide on option on the system level to set a `prefers reduced motion` setting, and you as a web developer can use that for reducing the motion using the [prefers-reduced-motion](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion){:target="\_blank"}{:rel="noopener noreferrer"} media query.

Tailwind has this built-in as utility classes

for `motion-safe`, but in case you want to use these for animation, make sure you add this to your Tailwind config:

```js
variants: {
  animation: ['motion-safe', 'motion-reduce'];
}
```

Then we can enable the animation only if the user has not preferred reduced motion by using the class `motion-safe:animate-marquee` and `motion-safe:overflow-x-hidden`. As a fallback

## Optimization

In our case we wanted to start the animation only after receiving the data. In this case we could use the `will-change` attribute to hint the browser that this element will be animated.

```css
.will-change-transform {
  will-change: transform;
}
```

See the MDN page for more information, and note the huge note there: https://developer.mozilla.org/en-US/docs/Web/CSS/will-change

> **Important:** will-change is intended to be used as a last resort, in order to try to deal with existing performance problems. It should not be used to anticipate performance problems.

Based on this note, I think I should actually not have used this, but instead measure the performance and only improve it if there are some performance problems.

## The Final Code and a Functional Codepen

Here, TODO

## Fun Fact

Even though `<marquee>` is deprecated, it's really not gone, the functionality is currently available in most web browsers but it's not recommended to use it as it can be removed any time in the future without a warning. See [the MDN page for marquee for more details](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/marquee){:target="\_blank"}{:rel="noopener noreferrer"}.

When I started drafting this blog post and used `<marquee>` in the `title` and `excerpt` of this post, the page contents started scrolling to left and I had to fix this by escaping the `title` and `excerpt` before rendering them as HTML.

![My webpage contents started scrolling, due to `<marquee>` in content]({{ "/images/19-marquee/marquee.gif" | prepend: site.baseurl }})

So, remember to escape your content, especially if it's input directly from your users.
