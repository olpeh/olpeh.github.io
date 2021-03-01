---
title: 'Do Yourself and Everyone a Service by Writing Good Commit Messages'
date: 2021-03-16 12:00:00 Z
layout: post
excerpt: 'Good commit messages are worth gold. This blog posts explains why this topic matters.'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
tags: git conventions practices
image: '/images/22-commits/gold.jpg'
altText: 'Blocks of gold.'
credits: 'Photo by Jingming Pan on Unsplash'
---

Somehow, I feel like the importance of good commit messages can not be overstated and a good commit message is worth its bytes weight in gold.

The most important thing to convey in a commit message in addition to what was changed is the **why** something was done in a certain manner. Quite often I look at some code changes and try to wonder **why** things were done like this even if `git blame` would say that it was me who did the change. In these cases, simple commit messages like `Use LibraryA instead of LibraryB` give no additional value. Instead of a better commit message in this case could have been something like this:

> Use LibraryA instead of LibraryB in order to avoid a bug in LibraryB
>
> There is a bug in LibraryB, that causes undefined behaviour in certain cases when the user clicks this button. Using LibraryA instead fixes the issue since the library does not use the problematic library “xyz” under the hood like LibraryB does
>
> For more information, check the release notes: xyz.github.io/releases/1.2.3

As you can see, this commit message tells the future you or anyone else bumping into the commit message the what and most importantly the **why** at a quick glance.

## Commits Should Only Contain Related Files and Changes

A commit message is like a label that is added to the line of code forever and the most recent label is most easily visible in editors and when using `git blame` or even in UIs like in GitHub.

This is why it is important to keep in mind that a commit should only contain changes that are related to the actual change described by the commit message.

Git blame, despite its negatively loaded name is a useful tool for inspecting the history of a file and you should be able to see **why** certain lines have been changed if good commit message practices have been in use.

## Commit Messages Are Not For Your PR

Commit messages are not supposed to be used to communicate something that happens in your PR. In fact, PRs are not part of `git` itself, but rather something that tools like GitHub and others have come up with and some people might even wonder what's the difference between git and GitHub.

This is also why I think good commit messages are

## Commit Messages Are Like Documentation

Good and clear commit messages act like documentation. Writing documentation is always painful, right? But if you do it immediately when commiting your code changes, it's not that big of an effort.

In order to learn more about the importance of clear commit messages, you can watch this amazing talk by my colleague and friend, Juhis: [Contemporary Documentation](https://hamatti.org/talks/contemporary-documentation/){:target="\_blank"}{:rel="noopener noreferrer"}.

## Good Commit Messages Makes Bisecting Easy

As I wrote in [one of my previous blog posts about git bisect](/2021/01/25/git-bisect-is-your-friend-in-need.html), `git bisect` is a powerful tool for quickly finding problematic commits. In those cases a clear commit message helps as well. Read the blog post for more.

## Commit Messages Can Be Used for Announcements

[Jani Eväkallio](https://twitter.com/jevakallio/status/1366317647965618177){:target="\_blank"}{:rel="noopener noreferrer"} recently published an interesting open source tool called [git-notify](https://github.com/jevakallio/git-notify){:target="\_blank"}{:rel="noopener noreferrer"}, which makes it possible to use git commit messages for announcing some important changes to your team members or even your future self.

I think this is a brilliant idea and may save a lot of frustration and time in larger development teams.

## Sometimes You Don’t Care and That’s Okay

Sometimes it’s okay to not care. Such cases include doing a hobby project in your free time and you are the only developer ever going to touch that codebase.

However, you never know what happens and suddenly you might not be the only person contributing to the codebase anymore. This is when good commit messages may save a lot of time and frustration by acting like a good documentation. Additionally, when the time passes and you are not actively working on the codebase, you most likely will forget some aspects of it. This is when your own commit messages turn to be helpful for you when you are trying to look at a piece of code and you have no recollection of **why** things were done in a certain way in the past.
