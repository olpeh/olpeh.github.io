# olpe.fi

Personal blog about development: [olpe.fi](https://olpe.fi)

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