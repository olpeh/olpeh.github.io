---
title: 'Conventions Don’t Matter – What Matters Is Consistency'
date: 2021-02-02 12:00:00 Z
layout: post
excerpt: "Agreed conventions can make a huge difference in a team's performance. Successful development teams often have agreed on a set of conventions that tries to follow. However, you should not copy the conventions from others, because the conventions don’t matter."
author: 'Olavi Haapala'
author_twitter: '0lpeh'
tags: conventions, teamwork, best practises, performance
image: '/images/16-conventions/myway.jpg'
altText: 'Photo of an ongoing renovation inside a building'
credits: 'Photo by Rommel Davila on Unsplash'
---

## Consistency Is the Key

When working in a larger development team, it is important to have clear conventions for different aspects of the projects. Some of the conventions could be about the team’s ways of working, but most time consuming debates usually are about code style and coding conventions. I personally think that the conventions really don’t matter. What matters is that everyone follows the agreed conventions consistently.

This is why code formatting tools, such as Prettier have become widely adopted and popular. Prettier puts an end to the non important discussions about coding style such as using or omitting semicolons trailing commas etc. in JavaScript or TypeScript projects. Prettier takes care of formatting the code and in your code reviews, you can focus on things that matter.

### Why Conventions Are Needed

However, there's a lot more into conventions than code formatting. Especially when using general purpose languages such as JavaScript or TypeScript or libraries such as React. There often are multiple ways of handling different scenarios in the code base. Sometimes developers working simultaneously on different branches implementing different features, but technically speaking solving a similar problem, may end up solving the problem in vastly different ways. Often, it is impossible to say that one of the ways is wrong and the other one not. What matters is that the coding conventions are consistent. This is why the team needs to agree on the conventions and then enforce them and train everyone in the team to follow the agreed conventions.

## Don't Blindly Copy Best Practises

There are a lot of examples of long form best practices and conventions written up, which you can check out and adopt in your team as it suits your team. Something that works for others, may not work in your cause though. It is always best to agree on the conventions that work for your team and project. However, I would argue that the conventions themselves are unimportant. The only thing that matters is that everyone is following the same conventions and doing so consistently. Over time, the code base should remain somewhat uniform to the extent it is possible.

You may think that is a bad idea, and stops innovation and adopting new trends and technologies. I dare to disagree. New conventions can be agreed on, and when a new convention is agreed on, it should be used in the codebase from that day on. Either by refactoring the whole code base to follow the new convention, which should be doable if the previous convention was followed carefully, or by using tools such as [phenomnomnominal/betterer](https://github.com/phenomnomnominal/betterer){:target="\_blank"}{:rel="noopener noreferrer"} to incrementally adopt a new convention, and stop anyone from adding new code that does not follow the newly agreed convention. It is equally important to document the agreed conventions and keep the documentation up-to-date over time.

## Conventions Should Not Be Carved in Stone

A team's conventions should be evolving as the team evolves, learns something new, and new members join the team. It is impossible to agree on perfect conventions that would cover all the future aspects taking into account all the things that are going to happen in the project, in the tech field and in the world. A good example of this is how many teams used to work mostly co-located at offices, but suddenly, due to COVID-19, had to switch to working fully remotely. This has forced teams to evolve their ways of working and conventions in order to adapt to the new situation and continue collaborating in an effective manner.

## What Works for Your Team

How are the conventions agreed on in your team? How do you document your conventions? What has been the most challenging topic to agree on? I would be interested to know that. You can reach out to me on [Twitter: @0lpeh](https://twitter.com/0lpeh/){:target="\_blank"}{:rel="noopener noreferrer"} or any other way that suits you best.
