---
title: 'Learn from Your Mistakes'
date: 2021-03-23 12:00:00 Z
layout: post
excerpt: 'As software developers, we aim to always be learning more. The best way to learn is to make mistakes and learn from those.'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
tags: learning sailfishos
---

In this blog post, I will be sharing what I have learned from creating and maintaining a Sailfish OS app for tracking working hours. It’s simply called [Working Hours Tracker](https://wht.olpe.fi/){:target="\_blank"}{:rel="noopener noreferrer"}. I started the project in 2014 and have been developing and maintaining it ever since. The most
recent version of the app was released on February 20, 2021.

![Working Hours Tracker App logo]({{ "/images/23-learn/whtcover.png" | prepend: site.baseurl }})

When I started the project back in 2014, I had quite little real world experience from software projects. I had been studying for a few years at that time, but we all know that most of the learning happens at work or when doing some side projects. My limited experience and knowledge led to some of the interesting mistakes made during the project, and I’ll cover some of those and what I learned from those.

## Background

You may not have heard about [Sailfish OS](https://sailfishos.org/){:target="\_blank"}{:rel="noopener noreferrer"}, and that’s fine. It’s not very widely known. It’s a mobile operating system developed by a Finnish company called [Jolla](https://jolla.com/about/){:target="\_blank"}{:rel="noopener noreferrer"}. They initially launched the OS together with their own devices, but later on they have been more focused on the development of the operating system and licensing it to different partners in addition to being close to bankruptcy twice.

Personally, I love the Sailfish OS, but there are still a few blockers for me to be running it on my main phone. The available hardware that is officially supported is not at a good enough level for my needs, especially when it comes to the camera.

Sailfish OS has still a small number of apps available in the store and a small number of community developers working on new apps. However, the small size of the community was one of the nice sides of my project. I think I was able to gain quite a lot of attention from the community because my app used to be the only time tracking application available in the Jolla Store. Check this [tweet about how excited I was when the app reached 2k downloads in the Jolla Store](https://twitter.com/0lpeh/status/721242967487463424){:target="\_blank"}{:rel="noopener noreferrer"}.

In 2014, I was using a Jolla phone as my main driver and had the need for tracking my work hours in an easy way. I also wanted to try out developing mobile applications and this seemed like a great idea at that time. The simple features and UI is developed mostly for my initial needs, until I started receiving feature wishes and feedback from the users.

## Getting Started

In order to get started with the development and building the initial version, I was looking at some of the example applications and code snippets and took heavy inspiration from a few Sailfish OS applications that were openly available in GitHub.

I built the whole application with a mindset of trying to build something without really knowing a lot about the platform or the best practices. I was happy when something seemed to work even though most of my solutions were not optimal. This was probably my first mistake, not figuring out how to properly design and implement a Sailfish OS application. But on the other hand, this was a great way to get something done and learn from your mistakes.

![Working Hours Tracker running on multiple SailfishOS devices.]({{ "/images/23-learn/devices.jpeg" | prepend: site.baseurl }})

## Lessons Learned

Here are a few selected lessons that I have learned while developing and maintaining this application for years. They are in no particular order and the list is not exhaustive.

### Qt and QML

Sailfish OS is based on Qt and the views are written in QML. Since I’m a web developer, I ended up doing most of my UI and features in QML, which is the equivalent of doing everything with JavaScript instead of doing the heavy lifting on the server side. In the Sailfish OS case that would mean Qt (C++) level. Correctly using C++ code that use signals to keep the UI up-to-date and to receive events, was something I only learned quite late in the project, when I took a closer look at the documentation and some more advanced example applications.

The heavy use of QML for data processing and other stuff that should have been handled more effectively, lead in some cases to somewhat unresponsive UI. Mostly, it has been fine, but that might have been only because I haven’t been using the application with large amounts of data.

Additionally, I ended up writing some of the data processing and grouping in JavaScript instead of doing that on the database level with SQL. This happened mostly because it happened slowly over time when adding new features and additionally, I might not have been aware of the powers and features of SQL.

### Backwards Compatibility

Backwards compatibility has been one the most annoying part of this project. I’ve had a goal to not break any of the earlier versions of the app, that someone might be upgrading from. This has led to some weird quirks and unnecessary migration checks that need to happen every time the application is started.

Sometimes, an update I worked on ended up breaking the application for many users and I had to do some more database migrations in order to fix the database for those users who now had invalid data in the database due to an invalid migration script.

In retrospective, I should probably not have cared so much about breaking the application for a few users at the cost of having to run unnecessary code for everyone every time the application is started. I think I could have earlier decided to release a v2 of the application that would not have been backwards compatible. Better database design from the start could have let to fewer migration needs.

### Database Design

Good database design is important. This is probably one of the parts of the project that has made me want to forget about the backwards compatibility and start everything all over again and release it as v2.

The database design basically did not exist at all. No foreign keys are used. Linking between hour markings and projects are done by looking for the project ID that is saved as a string on the hours row. Same goes for tasks inside projects and so on.

And did I mention the format the 2014-version-me decided to save the hour markings in?

The hours markings are saved in the following format (simplified):

- Date as TEXT
- startTime as TEXT (HH:MM!)
- endTime as TEXT (HH:MM!)
- Duration as REAL
- Breakduration as REAL

Why on earth did I want to save the startTime as a “HH:MM” string? You might realize what kind of issues this kind of crappy database design has led into. If I could go back in time I would change the database to at least save these as unix timestamps or datetimes.

This in addition to custom home made code for handling durations and displaying those as “HH:MM” is also why I ended up having bugs like [this reported by a user](https://github.com/olpeh/wht/issues/66){:target="\_blank"}{:rel="noopener noreferrer"}, displaying the time displayed as "150:60".

### Testing

Automated testing of the application should have been thought of at an early stage of the project. Way too late in the project, after releasing a few extremely buggy versions to users, I tried adding some unit tests to the project, but failed to get them working and gave up. Right now there are no automated tests in this project.

Additionally, as part of testing a version before releasing it, a plan or a script for the manual testing would have been useful. I usually only tested on a few different devices and only tested those features that I remembered to test. Quite often some features that I didn't think were affected by the changes I was working on, got broken by a bugfix targeted at another feature.

### Debugging

Even if a good level of testing is done, your users will end up in some weird corner cases at some point of the time. You are lucky if you hear about these from some of the users. It means they care enough to contact you. One thing that was super useful in these scenarios was that I created a way for the users to easily send me the application logs as email to me.

### Managing Releases and Release Notes

Managing release notes and releases in different platforms etc. takes surprisingly much effort. This is something you might want to consider automating as much as possible.

Current [release instructions for this project](https://github.com/olpeh/wht#releasing){:target="\_blank"}{:rel="noopener noreferrer"} consist of a list of 15 steps to go through when releasing a new version, and the release notes need to be copied to at least a few places.

Additionally, you might not want to list all of the features in the app in the documentation. I mean what’s the point? And especially, don’t do this in multiple places and services. Don’t do like I did.

### Documentation

This project has taught me the importance of good documentation. Even though it was mostly me alone working on this project, I would have benefitted from more documentation about the different aspects of the project.

This has become especially clear now when the project has not been in active development, but instead, I have been working on some random bug fixes every few months or years. I have even ended up having a bit of discussion with myself via some TODO comments in the codebase as you can see from the screenshot below or check the [lines in the codebase in GitHub with this link](https://github.com/olpeh/wht/blob/c38418b1ef2be2bce96ee71fc7f580133a4e42b2/src/WorkTimer.cpp#L91-L93){:target="\_blank"}{:rel="noopener noreferrer"}.

![Screenshot of the above linked code lines in GitHub, with the following contents: TODO: Why did I do it like this earlier? Plz refactor this Why did I comment like that?]({{ "/images/23-learn/todo.png" | prepend: site.baseurl }})

Something that I have learned is the importance of the following levels of documentation:
Readme, instructions how to get started etc.
Testing instructions
Release / deployment instructions, with enough detail
Good commit messages
Clear and good code comments where needed

### Managing Internationalization

I wanted to provide my application in multiple languages. For this, I have been using [Transifex](https://www.transifex.com/){:target="\_blank"}{:rel="noopener noreferrer"} which is a great tool for crowdsourced translations. I received surprisingly many contributions from the community in the Transifex project. The application is available in 10+ languages translated by more than 20 volunteers. A few weeks ago, someone requested to translate the app into Polish.

However, handling the different languages adds to the maintenance overhead of the project and makes the release process slightly more complicated. This is something I should have automated but never did.

### The Importance of a Supportive Community

For a platform to become successful, it is important to have an open and active community. I think the Sailfish OS developers community has been super helpful and there have been multiple people helping me a lot when I have had trouble with this project. Special shoutout to kimmoli and coderus for their help!

### Refactoring

Refactoring should happen in small phases and not in a big bang refactoring. I ended up working on a way too large refactoring that touched most of the codebase and I almost ended up giving up on it. The end result was a bit nicer codebase but with some newly introduced bugs. I never continued the refactorings further, so now the codebase is not as nice as I would like it to be.

There is a lot of duplication in the codebase, so one option would be to start getting rid of those piece by piece and after that start transforming the codebase oto a more recommended way of building UI applications in Qt. However, I most probably never will do this. Instead I would probably start from scratch and build a new version that would be better designed both from the technical perspective and the UX and UI perspectives.

## Don’t Start with Advanced Features Too Early

I made the mistake of implementing some advanced features such as email export, database export, CSV export and import as well. This led into more complex maintenance since I had to try to keep this in mind when thinking about fixing something or adding more features. Everything needed now to be backwards compatible and I tried to make sure importing a database dump would work even across different versions of the application.

To be honest I’m not even sure if this worked all the time, and I’m not sure if any of the users ever used these features. Lesson learned: focus on the core features.

### App Development Is Different from the Web Development

Web development is relatively easy in terms of updates. Most of the websites don’t utilize lots of local data on the users device. Of course some exceptions exist and LocalStorage is an example of local data stored on a user's device that sometimes needs migration etc. Most websites, you can deploy a new version at any time, and your users will get the new version when they load the page again.

In the world of mobile applications, you can’t just deploy a new version. What you can do is to submit a new version of the application to be reviewed. After approval, it will be available for your users to download from the app store if they wish to do so. Sailfish OS has no option for automatic updates and there is no way to force the users to upgrade.

My application is working fully offline with a local only database. This is a good idea from the users perspective, but could easily become a hell to maintain. In some cases having the data stored on a central server could be considered as a nice benefit. Especially if some database migrations need to take place.

On the web, pages may break easily due to changes in the backend API and some users may be keeping a tab open for months (true story BTW!). On the web, this is not considered critical, and the user is often told to try to refresh the page, close the browser and try again etc. On the native side however, an app crashing is usually considered more critical.

## Fun Facts about the Project

To end this blog post, I’d like to share a couple of fun facts about this projec.

### Fun Fact 1

Here’s a fun fact about how I built a solution for getting notifications for comments and reviews even though the platform did not have a support for this.

When submitting an app to be reviewed and added to the Jolla Store, there is or at least used to be a critical feature missing in the process: **notifications**. You would not get notified when your app got either approved or rejected. Additionally, you would not receive any notifications when users commented or rated your application in the store. The only way to notice that someone had commented or given a new review was to actually open the app store on a Sailfish OS device and check the comments there.

However, if you log into [harbour.jolla.com](https://harbour.jolla.com/){:target="\_blank"}{:rel="noopener noreferrer"} where the applications are submitted for review, you can see the amount of reviews and likes etc. for your own applications. At that time I did not realize there was an API also available for this data, so my solution was a bit more complicated than necessary.

#### My Solution for Notifications

I had a Selenium script running on an interval of 15minutes. The script would

- Open [harbour.jolla.com](https://harbour.jolla.com/){:target="\_blank"}{:rel="noopener noreferrer"}
- Log in
- Go to my applications
- Scrape the amount of reviews, likes etc. from the HTML
- Write those into a file
- Compare with previous values
- If they had changed, send a IRC message to myself with a text saying something like “Working Hours Tracker has received a new comment”

On my server where I was running my `irssi` IRC instance, I had a perl script running that would send an XMPP notification to myself for all the private messages I received.

On my mobile phone, I had an XMPP client installed, that would notify me of new XMPP message.

When receiving a message, I would then see that I need to open the Jolla Store and check the comment from there

My solution was complicated but it worked all the time, except from when it didn’t. Sometimes I needed to go kill some of the processes on the server after it started running out of memory because some Firefox processes were left running in the background for some reason. I never spent time on investigating why this happened, I simply killed those processes every once in a while.

Additionally I extended this solution to save the amount of downloads, likes and active installations into a database and I was able to visualize those on the web page using Highcharts. The solution is not working anymore, but it was visible on the homepage for this project: [wht.olpe.fi](https://wht.olpe.fi/){:target="\_blank"}{:rel="noopener noreferrer"}.

You can see how it used to look like in the screenshot below:

![Screenshot of the download stats for working hours tracker]({{ "/images/23-learn/downloads.png" | prepend: site.baseurl }})

### Fun Fact 2

Huge part of the users for my app seem to be from Germany for some reason. [See this tweet about WHT download stats in OpenRepos](https://twitter.com/0lpeh/status/555806583113146368){:target="\_blank"}{:rel="noopener noreferrer"}.

## The Most Important Lesson Learned

I think the most important lesson this project has taught me is that you learn by doing. I think the fact that I can laugh at the code I wrote a few years ago is a good sign because it means I have learned a bunch of things and if I were to start a similar project now, I would make better decisions and make new kinds of mistakes – but not the same stupid mistakes again.

This project has been supported by the Futurice Open Source sponsoring initiative: [Spice Program](https://spiceprogram.org/oss-sponsorship/){:target="\_blank"}{:rel="noopener noreferrer"}. In fact, this project probably helped me land a job at [Futurice](https://futurice.com/){:target="\_blank"}{:rel="noopener noreferrer"} in the first place.

Cheers for reading the post. This ended up being my longest blog post so far and I still would have wanted to write more, but I guess It's time to publish this.
