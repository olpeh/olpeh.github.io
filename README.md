# olavihaapala.fi

[![license](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/olpeh/olpeh.github.io/blob/master/LICENSE)

A blazing fast personal blog about development: [olavihaapala.fi](https://olavihaapala.fi).

Read about [how I set up my blog](https://olavihaapala.fi/2017/11/19/hello-world.html).

Read about [how I made my blog blazing fast](https://olavihaapala.fi/2019/02/19/how-i-made-my-blog-blazing-fast.html).

![4 times 100 in the lighthouse audit.](/images/08-blazing-fast/100.png)

Site setup inspired by [elmtown.audio](https://github.com/elmtown/elmtown.github.io)

## Running the site locally

1. Install ruby, bundler and jekyll
1. Go to the project directory on the terminal
1. Run `bundle install` to install deps
1. Install npm dependencies: `yarn`
1. Run `npm run dev` to serve the site locally

## Testing

Run `npm test`, which currently only runs a test against "production" version for visual regression.
The idea is to run this test before deploying changes that should not affect layout and then run it again after deploying those changes to verify that no visual regression took place.
