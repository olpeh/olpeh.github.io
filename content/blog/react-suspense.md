---
{
  'type': 'blog',
  'author': 'Olavi Haapala',
  'title': 'Using React Suspense in Production',
  'description': 'React 16.6 introduced React.lazy and React.Suspense for dynamic code splitting – I tried it out in a real world project',
  'image': '/images/react-suspense/react.png',
  'altText': 'React logo',
  'published': '2018-11-13',
}
---

The React dev community is currently going crazy about [React Hooks](https://reactjs.org/docs/hooks-intro.html), which is an experimental proposed feature in React 16.7-alpha.
Hooks look super interesting and show great promise.
The only downside is that you _can not_ and _should not_ start using them.
Not just yet.
The API is still under development and subject to changes.

In the midst of all the hype around the experimental features, some people may have forgotten that React 16.6 included some cool new features as well.
And they are in a stable version of React, which means they should be production ready.

## React lazy and Suspense

React 16.6, which was released on October 23, 2018, came with built-in support for code splitting using dynamic imports.
The feature for lazily importing component code is called react lazy.
React lazy allows you to use the dynamically imported component as if it was a normal component.
Suspense, on the other hand, is a feature that allows displaying fallback content in place of a component if the component's module is not loaded yet.

If you want to read more about React lazy and Suspense, go check out the [official documentation](https://reactjs.org/docs/code-splitting.html#reactlazy).
The React docs are great, by the way.
The 16.6 release contains other interesting features as well, such as `React.memo()`, which I haven't tried out yet.
[Take a look at the release notes here](https://github.com/facebook/react/releases/tag/v16.6.0).
Eventually, Suspense is going to be about more than just asynchronously loading and rendering components, in the future releases of React.
But let's stick to the stable version of React.

I wanted to give these features a try in a real world project.
My plan was to try it out in one project and if it would improve the performance or the user experience, I would take it into use in other projects as well.
At my current project work, we have 4 different projects of varying sizes using React.

## Getting Started with Suspense

Getting started was easy:
![Get started with React Suspense](/images/react-suspense/dan-abramov-on-twitter.png)
[Link to the original tweet](https://twitter.com/dan_abramov/status/1054940536161865729)
You could literally get started in 60 seconds as you can see from this [60s video](https://twitter.com/siddharthkp/status/1055063531328987136).

But, then again, in a real world project things aren't always that simple.
Before doing anything I had to upgrade a bunch of npm packages and then get started trying to use `React.lazy`.
The first thing that struck me when trying to use lazy was an error with types:

```typescript
.../node_modules/@types/react/index has no exported member 'lazy'
```

And similarly for `Suspense`, of course.
Apparently `@types/react` does not include types for the newest React version yet.
Which, happens because the types are maintained by the community and not React Developers at Facebook.

A TypeScript hack to work around this issue is telling the TypeScript compiler that React is of type `any`.

```typescript
// TODO: Import these properly when @types/react has them
const Suspense = (React as any).Suspense;
const lazy = (React as any).lazy;
```

Obviously, this is not recommended, and thus the TODO comment.
But hey, at least it works.

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

Please note that in this particular project we are pretty lucky.
We only need to support the newest desktop browsers.
This means that we can easily have esnext as our compilation target and use the newest of the new ES/TS features.

After that, I was able to get further, until the next error struck me:

```typescript
ERROR in ./main.tsx
Module build failed (from ../node_modules/babel-loader/lib/index.js):
Error: .plugins must be an array, or undefined
```

This error I was able to fix by modifying our webpack config for loading TypeScript files by simplifying it to always use ts-loader.
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

Side note: while writing this blog post, I realized, that I probably broke the hot loader feature in this project.

## Testing React lazy and Suspense in a production-like environment

So, everything seemed to work well locally.
The dynamic imports worked, the code splitting seemed to work, the application seemed to work and tests were passing.
Additionally, my co-workers had at this point reviewed my PR and added a few improvement suggestions and comments.
Everything looked good and I proceeded with deploying this feature to our testing environment, which (of course) uses webpack in production mode.

After deploying it to test environment, the test site was totally blank.
Nothing showed up, a fatal error prevented the app from rendering.
In fact, if you looked closely, the React app was actually bootstrapped and it was able to render something until it hit the first Suspended component and everything crashed.
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

This issue was quite difficult to find a reason for.
I asked around for help, and finally got help from [Juho Vepsäläinen](https://twitter.com/bebraw), who is one of the contributors of webpack.
He pointed out that the reason for this issue was not in my `ts-loader` or in my dynamic imports.
Rather, the cause for this issue was in my `css-loader` config, obviously.

## Further Configuring webpack :/

Juho told me that `extract-text-webpack-plugin` is deprecated in webpack 4 and using it is not recommended anymore.
I had to replace `extract-text-webpack-plugin` with `mini-css-extract-plugin`.
And that required some tuning to get it working.
Finally, after some hours of trying different config combinations, I had a working version.

However, the bundle sizes were huge, more than double the size of our bundles in production.
Asking [publicly about my problem in Twitter](https://twitter.com/0lpeh/status/1059479032146915328)helped.
I got some nice pointers and finally figured out the reason for increased bundle sizes.
The reason was, that in my config, I had replaced the default `minimizer` config in order to minimize the CSS in production mode.
The fact that I did not understand was that now webpack was not optimizing my JS bundles (because I did not tell it to do so).

So, having only:

```javascript
optimization: {
    minimizer: [new OptimizeCSSAssetsPlugin({})],
    ...
}
```

Only minimizes and optimizes CSS, not JS bundles.

In stead, I wanted to have:

```javascript
optimization: {
    minimizer: [new UglifyJsPlugin({}), new OptimizeCSSAssetsPlugin({})],
    ...
}
```

> So, the lesson here is that modifying the default config values changes the default config values.<br/>
> – Me, November 2018

## Route-based Code Splitting

As my trial of using Suspense was basically a proof-of-concept, I did not think thoroughly about where to use code splitting.
I just wanted to use it around some `large` components, that I thought were causing the bundle sizes to grow.
Luckily my co-worker pointed me to [the docs](https://reactjs.org/docs/code-splitting.html#route-based-code-splitting)where route-based code splitting is suggested.
This allows a simple way of splitting the bundles based on different views and is probably a good starting point for getting started with dynamic code splitting.
Further on, you should analyze your bundles in order to figure out what causes their sizes to become large and what could be possible opportunities for improvements.

Using a tool, such as [webpack-bundle-analyser](https://github.com/webpack-contrib/webpack-bundle-analyzer)may be a good option for analyzing your webpack bundles and their sizes, as suggested by [Tobias Kopperson](https://twitter.com/wSokra)as you can see in the screenshot below.

![Use bundle analyzer](/images/react-suspense/wsokra.png)
[Link to the original tweet](https://twitter.com/wSokra/status/1059475054419881984)

### Real-world example

Here is a code snippet of our project's `Root` component where the routes are defined.
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

Further down in the render part of our root component, we wrap all of the different routes with `<Suspense>` and give it a spinner component as the fallback.
The spinner will be displayed if loading the component code is slow.
This may or may not be good from the user experience point of view.

```tsx
render() {
    const matcher = this.props.match;

    return (
        <div className={style.container}>
            <Suspense fallback={<Spinner />}>
                <TopBar />
                <Route exact path={`${matcher.url}/`} component={MainView} />
                <Route
                  exact
                  path={`${matcher.url}/metrics`}
                  component={MetricsView}
                />
                <Route exact path={`${matcher.url}/faq`} component={FAQ} />
            </Suspense>
        </div>
    );
}
```

The way I wrote it initially was quite ugly, because I thought I had to wrap every component with Suspense.
Later on, I read some of the documentation and realized, it's possible to wrap multiple components inside a single `<Suspense>` component.

## Results

So, you may be interested in the results.
How much did our application get faster?
Does it feel faster?
Was it worth the effort?

Here is a screenshot of the network tab before using `Suspense`:
![Bundles before Suspense](/images/react-suspense/bundles-before-suspense.png)

And here is how it looks like after taking React.lazy and Suspense into use:
![Bundles with Suspense](/images/react-suspense/bundles-with-suspense.png)

Here is a screenshot of the lighthouse results before using `Suspense`:
![Lighthouse before Suspense](/images/react-suspense/lighthouse-before-suspense.png)

And here are the same results when using React.lazy and Suspense:
![Lighthouse with Suspense](/images/react-suspense/lighthouse-with-suspense.png)

As you can see from the screenshots, our component code is now splitted into more chunks, while the total JS stays roughly the same.
However, the lighthouse performance score did not improve, in fact it went down by 6 points.
This may just have been caused by small variations in lighthouse results, but the user experience is way more important than some performance scores.
On the other hand, the `First Contentful Paint` metric had improved by 800ms, which is nice, but then again `Time To Interactive` got worse.
The site now feels slightly faster (on slow connections) since component code is now loaded in chunks and a placeholder spinner is displayed if the loading takes long.

As an answer to the question "Was it worth the effort?", I would say yes, definitely.
The actual code changes were small, but we needed to update our config quite a lot.
Our current config is now more optimized and cleaner.
We now have support for dynamic imports in our config, which makes it easier to use new features in the future.
Also, updating packages always good.

## A Working webpack Config

Below, you can see the contents of our current working `webpack.config.js` file.
Bear in mind though, that this is the whole config file for our project, and includes more than just supporting dynamic imports and our TypeScript config.

```javascript
const webpack = require('webpack');
const path = require('path');

// variables
const isProduction = process.argv.indexOf('-p') >= 0;
const sourcePath = path.join(__dirname, './src');
const outPath = path.join(__dirname, '../public');

// plugins
const wtmlWebpackPlpack = require('html-webpack-plugin');
const webpackCleanupPlpack = require('webpack-cleanup-plugin');
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
    new webpackCleanupPlpack(),
    new MiniCssExtractPlugin({
      // Options similar to the same options in webpackOptpack.output
      path: outPath,
      filename: isProduction ? '[name].[hash].css' : '[name].css',
      chunkFilename: isProduction ? '[id].[hash].css' : '[id].css',
      publicPath: '/'
    }),
    new wtmlWebpackPlpack({
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

If you want to learn more about the new features in React version 16.6, check out [this post](https://reactjs.org/blog/2018/10/23/react-v-16-6.html) where the new features are introduced briefly.

My colleague, [Margarita](https://twitter.com/riittagirl) has written a super nice and easily understandable blog post about configuring webpack.
[You can read it here](https://hackernoon.com/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way-4e94c8e7e5c1).
And you definitely should read it!

The best way to learn a new thing is to try it out yourself.
So, go ahead and try it out!
You'll probably learn a lot more than you learn by reading blog posts.

## Acknowledgements

- Thanks to [Juho Vepsäläinen](https://twitter.com/bebraw)for helping me out with my broken webpack config
- Thanks to everyone who helped me [in this thread in Twitter](https://twitter.com/0lpeh/status/1059421088160145408)
- Thanks to [riittagirl](https://twitter.com/riittagirl) for writing an awesome [blog post](https://hackernoon.com/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way-4e94c8e7e5c1) about how to configure webpack 4
- Thanks to [Fotis](https://twitter.com/f_papado) for proofreading this blog post and suggesting improvements to it
