---
title: 'An open PR is the first 90% of the job – the other 90% remains'
date: 2021-02-02 12:00:00 Z
layout: post
excerpt: 'Estimating is hard and you probably knew it already. This blog post may or may not help you become better at it.'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
tags: estimating
# image: '/images/16-conventions/myway.jpg'
# altText: 'Photo of two signs that point to different directions. One says my way and the other one says highway.'
# credits: 'Photo by Rommel Davila on Unsplash'
---

## Author’s notice

You may have heard about the ninety-ninety rule in software engireening. In this post, I'm writing about my variation of the rule.

The point of this blog post is not to scare you, but rather to help you understand why estimation is difficult and often fails. You might need to update your mental model for estimations, or try to stay away from estimating if you can.

Additionally, I’m not trying to say you should not contribute to open source. You definitely should, but keep in mind that the work is not over when you have opened a pull request.

## The First Thing You Should Learn About Estimations

Estimating is **hard**.

Estimating is **challenging**.

Your estimates will probably be **too low**.

Estimating is **difficult**.

Your estimations **will be wrong**.

**Double** or **triple** your initial estimates – quite often **π** is a nice multiplier and there are some theories behind it as well.

You should probably try to **avoid having to do estimates** if possible.

If you have to estimate, take into account the **unkown unknowns**.

Did I mention estimating is **hard**?

### How Hard Can It Be?

Quite often you might be foolishly thinking that coding is the biggest part of creating new features of fixing existing bugs in a codebase. Sadly, this is rarely the case. In many cases, it's the other way round and the actual coding is the smallest part of the work.

### Based on Personal Experiences

This blog post is mostly based on my personal experiences in contributing to different open source projects and also my experiences at work related projects. Additionally, I have some experience in doing estimations for [my side business](https://iltametsuri.fi/){:target="\_blank"}{:rel="noopener noreferrer"}, where I provide tree removal services on my free time. My customers often want a fixed price for the job. It is often difficult to estimate how long time it takes to remove a tree. Many times, the seemingly biggest job of felling the tree is actually the fastest part of the job and the rest takes surprisingly long in comparison.

## The Ninety-Ninety Rule

The ninety-ninety rule is mostly meant as a joke, but it has some level of truth in it and in surprisingly many cases the final fixes and fine tuning takes way more time than expected – quite often the other other 90% of the time.

Here's a direct quote from [the Wikipedia page about the Ninety-ninety rule](https://en.wikipedia.org/wiki/Ninety-ninety_rule){:target="\_blank"}{:rel="noopener noreferrer"}:

> The first 90 percent of the code accounts for the first 90 percent of the development time. The remaining 10 percent of the code accounts for the other 90 percent of the development time.
>
> — Tom Cargill, Bell Labs

### My Variation of the Ninety-Ninety Rule

My variation of the ninety-ninety rule is as it says in the title of this blog post:

> An open PR is the first 90% of the job – the other 90% remains.
>
> — Olavi Haapala

It is often way too easy to only think about the time spent coding a fix or a feature when doing estimations. However, based on my experience, that accounts only for the first 90% of the time – the other 90% remains.

### Abandoned PRs Are the Worst

I have personally opened quite many PRs in open source libraries without taking into account the amount of work that remains after you open a PR. You most probably will receive some feedback about your code changes and need to modify the code. Additionally you might need to add more tests and documentation and communicate about the change. All of this, even if small changes and casual communication takes quite a lot of time and mental energy if nothing else.

Opening a PR and then abandoning it might be a huge burden on the maintainers. They need to keep communicating with you, checking up with your PR and waiting for you to contribute to the remaining 90% of the work.

So, when thinking about opening a PR to a open source repository, remember that the other 90% of the work still remains even if you have coded a fix or a new feature. Coding is "easy", but getting code finalized, approved, merged, and deployed is more challenging.

### Cost After Merge

In this blog post, I don't even talk about the costs and work after a fix or a feature has been shipped to production. That's a whole other story and this blog post would be too long if I would include that as well. However, that's a real fact and you should consider the total cost and effort required including the maintenance after deploying something.

## Things To Remember When Contributing Bug Fixes

First of all, check if someone has had the same issue and if it is already fixed or a simple workaround exists. Usually, you would start from the project's issues. If you’re not lucky, you’ll have to post a new issue and explain the problem and mention that you are willing to work on a fix for it.

Of course, these instructions may vary depending on the project you are contributing to, so take your time and read the contributing instructions which quite often are found either in the `README.md` or the `CONTRIBUTING.md` file. And if the instructions are missing, maybe that’s something you can and should contribute to first.

Now, that you have communicated the issue and your intent to fix it, you can start the actual coding work. After you have implemented a fix, there are a few more things to take into account:

1. Remember to write tests or update existing tests to match the new output. And especially in cases of bug fixes, write a failing test first before fixing the bug. This way you can make sure your fix works, and that the bug should not appear again in the future because your test should stop that from happening.

1. Write clear and descriptive commit messages with meaningful and logical chunks of code. I could write another blog post about the importance of good commit messages, but meanwhile you should watch this amazing talk by my colleague and friend, Juhis: [Contemporary Documentation](https://hamatti.org/talks/contemporary-documentation/)
