---
title: Hello world!
date: 2017-11-19 00:00:00 Z
layout: post
excerpt: "Setting up my personal blog and posting my first blog post"
author: "Olavi Haapala"
author_twitter: "0lpeh"
thumbnail: "/images/01-hello-world/thumbnail.png"
---

For a long time, I have been thinking about starting a blog. I have just never got it done. Last week I was participating in a `Thought Leadership Workshop` at work and got the boost needed for starting a blog. So, now, finally my blog sees the daylight! Amazing.

In my blog I'm going to write about software development and stuff that I have learned while programming.

So in order to get started with blogging, I'll start by writing about the steps that were needed in order to set up this blog. In this blog post I'm writing about how to setup HTTPS for a GitHub page using a custom domain.

## First step - custom domain

First step for me was to setup a custom domain (olpe.fi) to point to my github page (olpeh.github.io).

In the settings page for my repository in GitHub I could easily set up a custom domain for the github page as seen in the screenshot below.

![GitHub pages settings]({{ "/images/01-hello-world/gh-pages.png" | absolute_url }})

This was not enough though. Had to read the page behind the [Learn more](https://help.github.com/articles/using-a-custom-domain-with-github-pages/) link. In my opinion that page is quite confusing and I did not know what to do really.

In the end I found out that [this](https://help.github.com/articles/setting-up-an-apex-domain/#configuring-a-records-with-your-dns-provider/) was the page with the information that I needed:

>1. Confirm that you have added a custom domain to your GitHub Pages site.
>
>2. Contact your DNS provider for detailed instructions on how to set up A records.
>
>3. Follow your DNS provider's instructions to create two A records that point your custom domain to the following IP addresses:
>
>    192.30.252.153
>
>    192.30.252.154

So I went ahead and set up the correct `A` type records at my providers' page. See the screenshot below for the DNS records for the root domain `olpe.fi`. I also set up the same rules for `www.olpe.fi` in order to also support `www.olpe.fi`.

![DNS rules]({{ "/images/01-hello-world/dns-louhi.png" | absolute_url }})

This was enough to make my GitHub page (olpeh.github.io) available at [olpe.fi](olpe.fi) and [www.olpe.fi](www.olpe.fi). I was happy for a moment and tweeted this:

![DNS rules applied]({{ "/images/01-hello-world/tweet-dns-http.png" | absolute_url }})

## Next step - HTTPS

Next step was to enable and force using HTTPS in stead of HTTP on olpe.fi. Should be fairly simple to turn it on, right? And why is it not on by default? Nowadays browsers will show a warning if a page is served using HTTP instead of HTTPS and I also wanted to make my site available as a secure P2P site using dat in Beaker browser which requires HTTPS. More about those later.

However, it turns out GitHub does not support HTTPS for custom domains (yet)!

![No https support]({{ "/images/01-hello-world/tweet-no-https.png" | absolute_url }})

Well luckily I'm [not](https://github.com/isaacs/github/issues/156) the [only one](https://gist.github.com/coolaj86/e07d42f5961c68fc1fc8) wanting this feature and there are some workarounds available. I found a few nice tutorials about how to set up HTTPS for GitHub page with custom domain using Cloudfare (for free): [As a gist](https://gist.github.com/cvan/8630f847f579f90e0c014dc5199c337b) and a [blog post](https://blog.cloudflare.com/secure-and-fast-github-pages-with-cloudflare/) and [another](https://sheharyar.me/blog/free-ssl-for-github-pages-with-custom-domains/) and [one more](https://hackernoon.com/set-up-ssl-on-github-pages-with-custom-domains-for-free-a576bdf51bc).

I tried following those instructions pretty carefully but ended up redirecting from `https://www.olpe.fi` to `https://olpe.fi` and from there back to `www`. These steps included creating an account to cloudfare, adding `olpe.fi` as a site there, enabling flexible encryption mode using SSL and adding some redirection rules for forcing https.

In the end my working setup looked like this:

![Cloudfare crypto settings]({{ "/images/01-hello-world/cloudfare-crypto.png" | absolute_url }})

![Cloudfare page rules]({{ "/images/01-hello-world/cloudfare-page-rules.png" | absolute_url }})

`Nimipalvelin` means `name server` in Finnish.

![Louhi name servers]({{ "/images/01-hello-world/louhi-name-servers.png" | absolute_url }})

So now my site was available via [HTTPS](https://olpe.fi/) and [dat](dat://olpe.fi/) as seen in the screenshot below.

![HTTPS FTW]({{ "/images/01-hello-world/tweet-https-dat.png" | absolute_url }})

Dat support was something that I had configured earlier with the help of [this blog post](https://handbook.protozoa.nz/experiments/p2p_github_pages.html). P2P websites are available using [Beaker browser](https://beakerbrowser.com/) I will try to write more about P2P in a future blog post. In the meantime you can read about [Secure Scuttlebutt](https://www.scuttlebutt.nz/) and probably try it out using [Patchwork](https://github.com/ssbc/patchwork).


## Last step - the blog

At this point my "blog" was served over HTTPS but the only thing missing was the actual blog. I wanted to stay using a GitHub page based blog so jekyll was a natural choice for a static web page. I got a nice tip from my colleague about [elmtown.audio](https://github.com/elmtown/elmtown.github.io) which is a simple GitHub page with static content. That setup was pretty much enough for me and I copied most of the setup from there except for the visual outlook.

Next thing in my todo-list is to make the design of my blog better, but I'll just start off with some basic stylings and a simple looking blog.


## Acknowledgements

- Thanks to [Ossi Hanhinen](https://futurice.com/people/ossi-hanhinen) for giving me good hints on how to setup basic jekyll based static site. Reused the structure from: [elmtown.audio](https://github.com/elmtown/elmtown.github.io) which is made by Ossi
- Thanks to my wonderful colleagues at [Futurice](https://futurice.com/) for arranging a Thought Leadership Workshop where I got the boost needed in order to start blogging
- Thanks to all the people who wrote about how to setup HTTPS using Cloudfare
- Thanks to [Cloudfare](https://www.cloudflare.com/) for providing a free plan that has all the most critical features


