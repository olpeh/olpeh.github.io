---
title: 'Git Bisect Is Your Friend in Need'
date: 2021-01-25 20:44:00 Z
layout: post
excerpt: 'A practical story of how using git bisect has several times saved me a lot of time and helped me investigate somewhat mysterious problems in larger code bases.'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
tags: git bisect protip
image: '/images/15-git-bisect/stairs.jpg'
altText: 'Lake view with aurora in the background.'
---

## Debugging Is Hard

Sometimes you have to debug bugs that are confusing and you may have no clue why something happens. It may feel impossible to identify what is going on and why. Quite often in these cases, it would be helpful to know when did something start going wrong. In other words, it would be helpful to identify which particular commit caused the issue you are investigating. Not to blame anyone, but in order to find the problem and fix it. In fact, quite often it’s you yourself who have introduced the issue, so blaming won’t help as it never does.

## Git Has Superpowers

Git is a powerful tool, but some of its powers are underrated or unused. Maybe because not many people know how to use the more advanced or rarely used features of git. In this blog post, I’m going to explain how `git bisect` can be used to quickly identify a problematic commit. With the help of git bisect, you’re often able to save a lot of manual investigation when debugging challenging issues in your codebase.

## When to Use Git Bisect

Git bisect is a powerful tool and I recommend trying it out, especially if the following conditions are met:

1. You have an issue in your codebase
1. You don’t know what caused the issue but you want to fix it
1. You are able to find an older commit where the issue does not appear

## How to Use Git Bisect In Practice

1. Run `git bisect start`
1. Find and check out a commit where the issue happens. Most probably your latest commit has the issue you are investigating
1. Run `git bisect bad` to mark that commit as bad
1. Randomly check out an older commit and make sure the particular issue does not appear in it
1. Mark that commit as good by running `git bisect good`
1. Run `git bisect run`

Git will automatically checkout a commit for you using binary search algorithm to effectively help you find the problematic commit. Try reproducting the issue, and mark the commit as either bad or good: `git bisect bad|good`. Now, you should see something like this in your terminal output:

```bash
git bisect good
Bisecting: 183 revisions left to test after this (roughly 8 steps)
[7aa559c43a988b0c9e189411f785f0e753a48721] Merge remote-tracking branch 'origin/whatever-branchname into another-branchname
```

After you have done the marking enough times, which should not take too long. Git will be able to tell you which commit first introduced the particular problem. In my case the output looked something like this:

```bash
➜ git:(d76efd76e) ✗ git bisect bad
d76efd76e08307f75e4cd1fca4d5f332b3933753 is the first bad commit
commit d76efd76e08307f75e4cd1fca4d5f332b3933753
Author: Olavi Haapala <email@redacted.com>
Date: Tue Oct 27 11:34:28 2020 +0200
>
Upgrade next from 9.4.4 to 9.5.5
>
package.json | 2 +-
yarn.lock | 1139 +++++++++++++++++++++++++++++-----------------------------
2 files changed, 561 insertions(+), 580 deletions(-)
```

In this case the particular problem was introduced already a few months ago, when I upgraded Next.js from 9.4.4 to 9.5.5. Notice, how this also highlights the importance of good commit messages. I was immediately able to see what this commit was doing and could take a look at the release notes for Next.js to investigate why this issue got introduced. It would have taken me hours and hours to manually go through all the hundreds of commits after this bug got introduced. Git bisect saved me from doing that.

## Almost Done

After you have found out the cause for a problem, the work is almost done. Fixing a known issue takes almost no time compared to hunting a problematic piece of code from a larger code base. Of course this is not always true, but in most cases it is.

## Save Even More Time When Using Git Bisect

If you want to save even more time when using git bisect to hunt down a problematic commit, you can let git automatically check if the commits are bad or good. After the command `git bisect run`, you can give a command to be run which determines if a commit is good or bad. In some cases it could be running your tests or in other cases you could make a script that looks for something else that goes wrong. Git bisect opens up a world of possibilities beyond manually checking different commits and PRs and trying to guess when a problem first started appearing.

Here's a screenshot of a tweet I sent a few years ago about enjoying the magic of git bisect:

[![Me on my laptop in front of a fireplace]({{ "/images/15-git-bisect/tweet.png" | prepend: site.baseurl }})](https://twitter.com/0lpeh/status/1042720270522429440){:target="\_blank"}{:rel="noopener noreferrer"}

If you haven't used `git bisect` before, please give it a try. I promise you will save some time after you learn to effectively use it.
