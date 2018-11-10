---
title: Using React Suspense in production
date: 2018-11-07 00:00:00 Z
layout: post
excerpt: "React 16.6. introduced React.lazy and React.Suspense for dynamic code splitting – I tried it out in a real world project"
author: "Olavi Haapala"
author_twitter: "0lpeh"
thumbnail: "/images/03-react-suspense/react.png"
---

The React dev community is going crazy about React Hooks, which is an experimental proposed feature in React 16.7-alpha.
Hooks look super interesting and show great promise.
The only downside is that you *can not* and *should not* start using them. Not just yet.

In the midst of all the hype around the experimental features, some people may have forgotten that React 16.6 included some cool new features as well.
And they are in a stable version of React, which means they should be production ready.

## React lazy and Suspense

React 16.6., which was released on October 23, 2018 came with built-in support for code splitting using dynamic imports.
The feature for lazily importing components is called react lazy.
React lazy allows you to use the dynamically imported component as if it was a normal component.

Suspense, on the other hand, is a feature that allows displaying a fallback content in place of a component if the component's module is not loaded yet.

If you want to read more about React lazy and Suspense, go check out the [official documentation](https://reactjs.org/docs/code-splitting.html#reactlazy){:target="_blank"}.
The React docs are great, by the way.

I wanted to give these features a try in a real world project.
My plan was to try it out in one project and if it would improve the performance or the user experience, I would take it into use in other projects as well.
At my current project work, we have 4 projects using React.

The 16.6 release contains other interesting features as well, such as `React.memo()`, which I haven't tried out yet.
Take a look at the release notes [here](https://github.com/facebook/react/releases/tag/v16.6.0){:target="_blank"}.

Additionally, Suspense is going to be about more than just about asyncronously loading rendering components in the future releases of React.

But let's stick to the stable version of React.

## Getting Started with Suspense

Getting started was easy:

![Get started with React Suspense]({{ "/images/03-react-suspense/dan-abramov-on-twitter.png" | prepend: site.baseurl }})
[Link to the original tweet](https://twitter.com/dan_abramov/status/1054940536161865729){:target="_blank"}

You could literally get started in 60 seconds as you can see from [this 60s video](https://twitter.com/siddharthkp/status/1055063531328987136){:target="_blank"}

But, then again, in a real world project things aren't always that simple.
Before doing anything I had to upgrade bunch of npm packages and then start trying to use `React.lazy`.
The first thing that struck me when trying to use lazy was a typing error:

```typescript
.../node_modules/@types/react/index has no exported member 'lazy'
```
And similarly for `Suspense`, of course.

Apparently `@types/react` does not include types for the newest React version yet.
Which, in my opinion is super weird.

A TypeScript hack to work around this issue is telling the TypeScript compiler that React is of type `any`.

```typescript
// TODO: Import these properly when @types/react has them
const Suspense = (React as any).Suspense;
const lazy = (React as any).lazy;
```

Obviously, this is not recommended, and thus the TODO comment.
At least it works.

After this, the obvious error in my setup was, that our config did not support dynamic imports.
I had to make the following change to our `tsconfig.json` file:

```diff
  "compilerOptions": {
    "sourceMap": true,
-    "target": "es5",
+    "target": "esnext",
    "jsx": "react",
-    "module": "es6",
+    "module": "esnext",
```

After that, I was able to get further, until the next error struck me:

```typescript
ERROR in ./main.tsx
Module build failed (from ../node_modules/babel-loader/lib/index.js):
Error: .plugins must be an array, or undefined
```

This error I was able to fix by modifying our WebPack config for loading TypeScript files by simplyfying it to always use ts-loader.
As my colleague pointed out, we were using babel, even though we actually did not need it in a TypeScript project.

```diff
rules: [
    // .ts, .tsx
    {
    test: /\.tsx?$/,
-    use: isProduction
-        ? 'ts-loader'
-        : ['babel-loader?plugins=react-hot-loader/babel', 'ts-loader']
+    use: 'ts-loader'
    },
```

Additionally, because of upgrading most of the npm packages used by the project, I had a few deprecation warnings and the tests were not passing at this point.
These were easy to fix, since the deprecation warnings usually tell you what to do and the test failure error was pretty easy to DuckDuckGo.

## Testing React lazy and Suspense in a production-like environment

So, everything seemed to work well locally.
The dynamic imports worked, the code splitting seemed to works, the application seemed to work and tests were passing.
Additionally, my co-workers had at this point reviewed my PR and added a few improvement suggestions and comments.

Everything looked good and I proceeded with deploying this feature to our testing environment, which uses (of course) webpack production mode.

After deploying it to test environment, the test site was totally blank.
Nothing showed up, a fatal error prevented the app from rendering.

In fact, if you looked closely, the React app was actually bootsrapped and it was able to render something until it hit the first Suspended component and everything crashed.

The console looked like this:

```typescript
react-dom.production.min.js:181 TypeError: Cannot read property 'call' of undefined
    at i (bootstrap:83)
    at Object.60 (style.css:1)
    at i (bootstrap:83)
    at Object.35 (style.css?e2d7:2)
    at i (bootstrap:83)
    at Module.73 (style.css:11)
    at i (bootstrap:83)
yo @ react-dom.production.min.js:181
Co.n.callback @ react-dom.production.min.js:189
cr @ react-dom.production.min.js:128
ur @ react-dom.production.min.js:128
Pa @ react-dom.production.min.js:228
Ma @ react-dom.production.min.js:218
Ta @ react-dom.production.min.js:217
Sa @ react-dom.production.min.js:214
Yo @ react-dom.production.min.js:210
Promise.then (async)
Uo @ react-dom.production.min.js:204
Ma @ react-dom.production.min.js:218
Ta @ react-dom.production.min.js:217
Sa @ react-dom.production.min.js:214
Ko @ react-dom.production.min.js:212
Ra @ react-dom.production.min.js:234
Fa @ react-dom.production.min.js:234
Wa.render @ react-dom.production.min.js:242
(anonymous) @ react-dom.production.min.js:245
Ia @ react-dom.production.min.js:231
Va @ react-dom.production.min.js:245
render @ react-dom.production.min.js:247
134 @ main.tsx:18
i @ bootstrap:83
t @ bootstrap:45
r @ bootstrap:32
(anonymous) @ b81af0993190d6fb738f.js:1
bootstrap:83 Uncaught (in promise) TypeError: Cannot read property 'call' of undefined
    at i (bootstrap:83)
    at Object.60 (style.css:1)
    at i (bootstrap:83)
    at Object.35 (style.css?e2d7:2)
    at i (bootstrap:83)
    at Module.73 (style.css:11)
    at i (bootstrap:83)
```

## Further Configuring WebPack :/

I had to replace extract-text-webpack-plugin (which apparently is deprecated in wp4) with mini-css-extract-plugin. And that required some tuning to get it working.
Finally, I had a working version, but the bundle sizes were huge. I got it figured out yesterday after asking publicly in Twitter:
https://twitter.com/0lpeh/status/1059479032146915328
So, having only
optimization: {
    minimizer: [new OptimizeCSSAssetsPlugin({})],


Only minimizes and optimizes CSS, not JS bundles

## Route-based Code Splitting

As my trial of using Suspense was basically just a proof-of-concept, I did not think about where to use code splitting.
I just wanted to use it around some `big` components, that I thought were causing the bundle sizes to grow.
Luckily my co-worker pointed me to [the docs](https://reactjs.org/docs/code-splitting.html#route-based-code-splitting){:target="_blank"} where route-based code splitting is suggested.
This allows a simple way of splitting the bundles based on different views and is probably a good starting point for getting started with dynamic code splitting.
Further on, you should analyze your bundles in order to figure out what causes their sizes to become large and what could be possible opportunities for improvements.

Using a tool, such as [webpack-bundle-analyser](https://github.com/webpack-contrib/webpack-bundle-analyzer){:target="_blank"} may be a good option for analyzing your Webpack bundles and their sizes, as suggested by [Tobias Kopperson](https://twitter.com/wSokra){:target="_blank"} as you can see in the screenshot below.

![Get started with React Suspense]({{ "/images/03-react-suspense/wsokra.png" | prepend: site.baseurl }})
[Link to the original tweet](https://twitter.com/wSokra/status/1059475054419881984){:target="_blank"}

### Real-world example

Here is a code snippet of our projects' `Root` component where the routes are defined.
The imports for different components are using React.lazy for dynamic importing.
We are using TypeScript in our project, but as you can see from the snippet, the typings for React do not contain Suspense and lazy yet.
As a workaround, to ignore the type errors, you can just tell the TypeScript compiler that React is of type `any` and it will ignore errors when accessing properties or methods that should not exist according to the type definitions.

```typescript
import * as React from 'react';
// TODO: Import these properly when @types/react has them
const Suspense = (React as any).Suspense;
const lazy = (React as any).lazy;

// Code splitted imports
const TopBar = lazy(() => import('app/components/TopBar'));
const MainView = lazy(() => import('app/containers/MainView'));
const MetricsView = lazy(() => import('app/containers/MetricsView'));
const FAQ = lazy(() => import('app/components/FAQ'));
```

Further on in the render part of our root component, we wrap all of the different routes with `<Suspense>` and give it a spinner component as the fallback.
The spinner will be displayed if loading the component code is slow.
This may or may not be good from the user experience point of view.

```tsx
render() {
    const matcher = this.props.match;

    return (
        <div className={style.container}>
            <Suspense fallback={<Spinner />}>
                <TopBar />
            </Suspense>
            <Suspense fallback={<Spinner />}>
                <Route exact path={`${matcher.url}/`} component={MainView} />
            </Suspense>
            <Suspense fallback={<Spinner />}>
                <Route
                exact
                path={`${matcher.url}/metrics`}
                component={MetricsView}
                />
            </Suspense>
            <Suspense fallback={<Spinner />}>
                <Route exact path={`${matcher.url}/faq`} component={FAQ} />
            </Suspense>
        </div>
    );
}
```


## A Working Webpack Config

```javascript
const webpack = require('webpack');
const path = require('path');

// variables
const isProduction = process.argv.indexOf('-p') >= 0;
const sourcePath = path.join(__dirname, './src');
const outPath = path.join(__dirname, '../public');

// plugins
const HtmlWebpackPlugin = require('html-webpack-plugin');
const WebpackCleanupPlugin = require('webpack-cleanup-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');

module.exports = {
  context: sourcePath,
  entry: {
    main: './main.tsx'
  },
  output: {
    path: outPath,
    filename: 'bundle.js',
    chunkFilename: '[chunkhash].js',
    publicPath: '/'
  },
  target: 'web',
  resolve: {
    extensions: ['.js', '.ts', '.tsx'],
    // Fix webpack's default behavior to not load packages with jsnext:main module
    // (jsnext:main directs not usually distributable es6 format, but es6 sources)
    mainFields: ['module', 'browser', 'main'],
    alias: {
      app: path.resolve(__dirname, 'src/app/'),
      assets: path.resolve(__dirname, 'src/assets/')
    }
  },
  module: {
    rules: [
      // .ts, .tsx
      {
        test: /\.tsx?$/,
        use: 'ts-loader'
      },
      // css
      {
        test: /\.css$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            options: {
              sourceMap: !isProduction,
              modules: true,
              localIdentName: '[local]__[hash:base64:5]'
            }
          },
          {
            loader: 'postcss-loader',
            options: {
              ident: 'postcss',
              plugins: [
                require('postcss-import')({ addDependencyTo: webpack }),
                require('postcss-url')(),
                require('postcss-cssnext')(),
                require('postcss-reporter')(),
                require('postcss-browser-reporter')({
                  disabled: isProduction
                })
              ]
            }
          }
        ]
      },
      // static assets
      { test: /\.html$/, use: 'html-loader' },
      {
        test: /\.(png|jp(e*)g|svg|ico|gif)$/,
        use: [
          {
            loader: 'url-loader',
            options: { limit: 10000, name: 'images/[hash]-[name].[ext]' }
          }
        ]
      }
    ]
  },
  optimization: {
    minimizer: [new UglifyJsPlugin({}), new OptimizeCSSAssetsPlugin({})],
    splitChunks: {
      name: true,
      cacheGroups: {
        commons: {
          chunks: 'initial',
          minChunks: 2
        },
        vendors: {
          test: /[\\/]node_modules[\\/]/,
          chunks: 'all',
          priority: -10
        }
      }
    },
    runtimeChunk: true
  },
  plugins: [
    new WebpackCleanupPlugin(),
    new MiniCssExtractPlugin({
      // Options similar to the same options in webpackOptions.output
      path: outPath,
      filename: isProduction ? '[name].[hash].css' : '[name].css',
      chunkFilename: isProduction ? '[id].[hash].css' : '[id].css',
      publicPath: '/'
    }),
    new HtmlWebpackPlugin({
      template: 'assets/index.html',
      favicon: 'assets/favicon.ico'
    })
  ],
  devServer: {
    contentBase: sourcePath,
    hot: true,
    inline: true,
    historyApiFallback: {
      disableDotRule: true
    },
    stats: 'minimal'
  },
  devtool: isProduction ? 'source-map' : 'cheap-module-eval-source-map',
  node: {
    // workaround for webpack-dev-server issue
    // https://github.com/webpack/webpack-dev-server/issues/60#issuecomment-103411179
    fs: 'empty',
    net: 'empty'
  }
};

```

## Learn More

If you want to learn more about the new features in React version 16.6, check out [this post](https://reactjs.org/blog/2018/10/23/react-v-16-6.html){:target="_blank"} where the new features are introduced briefly.

My colleague, [Margarita](https://twitter.com/riittagirl){:target="_blank"} has written a super nice and easily understandable blog post about configuring webpack.
[You can read it here](https://hackernoon.com/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way-4e94c8e7e5c1){:target="_blank"}.
And you definitely should read it!

The best way to learn a new thing is to try it out yourself.
So, go ahead and try it out!
You'll probably learn a lot more than you learn by reading blog posts.

## Acknowledgements

- Thanks to [Juho Vepsäläinen](https://twitter.com/bebraw){:target="_blank"} for helping me out with my broken WebPack config
- Thanks to everyone who helped me [in this thread in Twitter](https://twitter.com/0lpeh/status/1059421088160145408){:target="_blank"}
- Thanks to [riittagirl](https://twitter.com/riittagirl){:target="_blank"} for writing an awesome [blog post](https://hackernoon.com/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way-4e94c8e7e5c1){:target="_blank"} about how to configure WebPack 4
