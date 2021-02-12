---
title: 'An open PR is the first 90% of the job – the other 90% remains'
date: 2021-02-16 12:00:00 Z
layout: post
excerpt: 'Estimating is hard and you probably knew it already. This blog post may or may not help you become better at it.'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
tags: estimating 90-90-rule
---

## Foreword

You may have heard about the ninety-ninety rule in software engireening. This post intorduces my variation of the rule.

The point of this blog post is not to scare you, but rather to help you understand why estimation is difficult and often fails. You may need to update your mental model for estimations. Unless you are a seasoned developer with lots of experience in estimating, my advice is to try to stay away from estimating if you can.

## The First Thing You Should Learn About Estimations

Estimating is **hard**.

Estimating is **challenging**.

Your estimates will probably be **too low**.

Estimating is **difficult**.

Estimating is **guessing**.

Your estimations **will be wrong**.

**Double** or **triple** your initial estimates – quite often **π** is a nice multiplier and there are some theories behind it as well.

You should probably try to **avoid having to do estimates** if possible.

If you have to estimate, try to take into account the **unkown unknowns**.

Did I mention estimating is **hard**?

### How Hard Can It Be?

Quite often, you might be foolishly thinking that coding is the biggest part of creating new features or fixing existing bugs in a product. Sadly, this is rarely the case. In many cases, it's the other way round and the actual coding is the smallest part of the total amount of work. Investigations, debugging, testing, QA, communication, and documenting tend to take most of the time.

### Based on Personal Experiences

This blog post is mostly based on my personal experiences in contributing to different open source projects and also my experiences at work related projects. Additionally, I have some experience in doing estimations for [my side business](https://iltametsuri.fi/){:target="\_blank"}{:rel="noopener noreferrer"}, where I provide tree removal services on my free time. My customers often want a fixed price for the job. It is often difficult to estimate how long time it takes to remove a tree. Many times, the seemingly biggest job of felling the tree is actually the fastest part of the job and the rest takes surprisingly long in comparison. Even though the field is completely different from software development, I can see some similarities in how challenging the estimations are.

## The Ninety-Ninety Rule

I believe the ninety-ninety rule was originally meant as a joke, but it has some level of truth in it and in surprisingly many cases the final fixes and fine tuning takes way more time than expected – quite often the other other 90% of the time.

Here's a direct quote from [the Wikipedia page about the Ninety-ninety rule](https://en.wikipedia.org/wiki/Ninety-ninety_rule){:target="\_blank"}{:rel="noopener noreferrer"}:

> The first 90 percent of the code accounts for the first 90 percent of the development time. The remaining 10 percent of the code accounts for the other 90 percent of the development time.
>
> — Tom Cargill, Bell Labs

### My Variation of the Ninety-Ninety Rule

My variation of the ninety-ninety rule is as it says in the title of this blog post:

> An open PR is the first 90% of the job – the other 90% remains.
>
> — Olavi Haapala

It is often way too easy to only think about the time spent coding a fix or a feature when doing estimations. However, based on my experience, that accounts only for the first 90% of the time – the other 90% remains. After you have coded something and opened a PR, there's still quite a lot of work remaining and you should be focusing on finaling one task all the way to prod before starting a new one.

### Abandoned PRs Are the Worst

I have personally opened quite many PRs in open source libraries without taking into account the amount of work that remains after you open a PR. You most probably will receive some feedback about your code changes and need to modify the code. Additionally you might need to add more tests and documentation, and communicate about the changes. All of this, even if small changes and casual communication takes quite a lot of time and mental energy if nothing else.

Opening a PR and then abandoning it might be a huge burden for the maintainers. They need to keep communicating with you, checking up with your PR and waiting for you to contribute to the remaining 90% of the work.

So, when thinking about opening a PR to a open source repository, remember that the other 90% of the work still remains even if you have coded a fix or a new feature. Coding is "easy", but getting code finalized, approved, tested, merged, and deployed is more challenging. And don't forget the feedback and possible changes from your users after you have deployed a change or a fix.

### Maintenance Cost

In this blog post, I don't even talk about the costs and work after a fix or a feature has been shipped to production. That's a whole other story and this blog post would be too long if I would include that as well. However, that's a real fact and you should consider the total cost and effort required including the maintenance after deploying something.

## Things to Take into Account

When working on a bugfix or a new feature to a codebase, there are a few things you should take into account. I'm here focusing mostly on open source libraries, but the same probably applies to most projects.

First of all, check if someone has had the same issue and if it is already fixed or a simple workaround exists. Usually, you would start from the project's issues. If you’re not lucky, you’ll have to post a new issue and explain the problem and mention that you are willing to work on a fix for it.

Of course, these instructions may vary depending on the project you are contributing to, so take your time and read the contributing instructions which quite often are found either in the `README.md` or the `CONTRIBUTING.md` file. And if the instructions are missing, maybe that’s something you can and should contribute to first.

Now, that you have communicated the issue and your intent to fix it, you can start the actual coding work. Try to follow the existing code style in the code base and avoid fancy abstractions that are not readable by others. Keep in mind that code is mostly read instead of written so readability is more important than the amount of code lines.

### What's Next

After you have implemented a fix, there are a few more things to take into account:

1. Remember to write tests or update existing tests to match the new output. And especially in cases of bug fixes, write a failing test first before fixing the bug. This way you can make sure your fix works, and that the bug should not appear again in the future because your test should stop that from happening.

1. Write clear and descriptive commit messages with meaningful and logical chunks of code. I could write another blog post about the importance of good commit messages, but meanwhile you should watch this amazing talk by my colleague and friend, Juhis: [Contemporary Documentation](https://hamatti.org/talks/contemporary-documentation/)

1. Write a clear description for your PR with possible screenshots before and after, explanations for why things were done in a certain way, and instructions for testing your code changes.

1. Check that your code has no conflicts, and double check that your changes still work. If something worked yesterday, it does not mean it works today.

1. Respond to feedback on your PR even if you disagree or if you don't need to change anything. Thank the reviewers. If you receive change requests, implement those changes and go back to step 4.

1. The next steps depend on the project: in some projects you merge your changes yourself and deploy to prod, but in many cases you need to wait for the maintainers to merge and release a new version.

## Closing Words

I hope this blog post was at least somewhat useful to you.

If you did not pick up anything else from this blog post, at least you can keep in mind that estimating is hard.
