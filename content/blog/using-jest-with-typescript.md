---
{
  'type': 'blog',
  'author': 'Olavi Haapala',
  'title': 'Using Jest with TypeScript',
  'description': 'Jest is a nice testing framework for frontend projects. However, sometimes it’s a PITA to set up in projects using TypeScript. This time I decided to write down the steps required to get it running.',
  'image': '/images/jest/jest.jpg',
  'altText': 'Jest output',
  'published': '2019-02-04',
}
---

# EDIT – Feb 5, 2019

As a few helpful people pointed out, there is a much simpler way than what I explain in this blog post.

I was able to achieve the same result with this, a lot simpler config:

Package.json:

```json
"scripts": {
  ...
  "pretest": "npm run lint",
  "test": "jest --verbose",
  "watch": "jest --verbose --watchAll",
  "no-watch-test": "jest --verbose"
},
"jest": {
  "preset": "ts-jest",
  "testMatch": ["**/__tests__/**/*.ts?(x)", "**/?(*.)+(spec|test).ts?(x)"],
  "moduleNameMapper": {
    "^.+\\.css$": "identity-obj-proxy",
    "^(app/.+)$": "<rootDir>/src/$1/",
    "^(components/.+)$": "<rootDir>/src/$1/",
    "^(stores/.+)$": "<rootDir>/src/$1/",
    "^(views/.+)$": "<rootDir>/src/$1/",
    "^(assets/.+)$": "<rootDir>/src/$1/",
    "^(models/.+)$": "<rootDir>/src/$1/"
  },
  "setupFiles": ["./scripts/setupJest.js"]
}
```

This way, I'm able to use the newest version of jest, and ts-jest takes care of the ts support.

Additionally, I realized the `--verbose` flag gives a pretty nice output from jest when running tests.

You can, however read the blog post if you want.

<hr/>

# What is Jest?

In my [previous blog post](/blog/my-opinionated-setup-for-web-projects), I explained my preferred project setup.
I mentioned about using Jest for testing, but not about how to set it up.
In this blog post I will explain how to set up Jest with TypeScript.

[Jest](https://jestjs.io/) is a testing framework made by FB and it is popular in React based projects. One of the reasons for its popularity is that [create-react-app, CRA](https://github.com/facebook/create-react-app) uses it. CRA is a good option for quickly getting a React project up and running.

Jest is easy to use, has a nice watch mode, snapshot testing, coverage reporting and other useful features. However, getting it set up for a TypeScript project has provent to be quite a PITA. This blog post will list the steps required for seting jest up and how to solve the problems during the setup.

## Step #0 – Getting Started

Search for how to get started with `jest`.
You will most probably end up in the [jest documentation](https://jestjs.io/).

First things that you will see on the page are:

- “It works with TypeScript” – Oh, well let’s see about that
- “Zero config” – Ok, cool

There is [a guide for getting started](https://jestjs.io/docs/en/getting-started), which lists the first steps for getting started.

Install the library:

```bash
npm install --save-dev jest
```

Add the test script to your `package.json`:

```json
"scripts": {
  ...
  "test": "jest"
}
```

Run it:

```
npm test
```

So far so good.
Jest looks for test files but does not find any.

## Step #1 – First Test

First, let's try to create a dummy test that does nothing in a file test called `test.js`:

```js
test('dummy test that does nothing', () => {
  expect(true).toBe(true);
});
```

This works fine.

## Step #2 – Switch to TypeScript

However, that was JS, and we want to be able to write tests in TS.

Moving to TS requires type definitions for jest and `ts-jest`.
Install them:

```bash
npm install --save-dev @types/jest ts-jest
```

Alright, the test is now called test.ts.
Let's try running it, works fine for the dummy test.

## Step #3 – Test a Component

Try to use render a simple component in the test:

The test file looks like this:

```ts
import { h } from 'preact';
import { render } from 'preact-testing-library';

import { SoMeWrapper } from './index';

describe('SoMeWrapper', () => {
  it('matches snapshot', () => {
    expect(render(<SoMeWrapper />)).toMatchSnapshot();
  });
});
```

Where `SoMeWrapper` is just a simple wrapper component.
As you can see, we are using `preact` in combination with [preact-testing-library](https://github.com/antsmartian/preact-testing-library).
Here we try to render the component and compare it to a saved snapshot of the output.
If the snapshot file does not exist, jest will create it on the first run.
Snapshots are stored as JSON.

However, this does not work and gives the following error:

```bash
Error

> jest

FAIL src/components/SomeWrapper/test.ts
● Test suite failed to run

    Jest encountered an unexpected token

    This usually means that you are trying to import a file which Jest cannot parse, e.g. it's not plain JavaScript.

    By default, if Jest sees a Babel config, it will use that to transform your files, ignoring "node_modules".

    Here's what you can do:
     • To have some of your "node_modules" files transformed, you can specify a custom "transformIgnorePatterns" in your config.
     • If you need a custom transformation specify a "transform" option in your config.
     • If you simply want to mock your non-JS modules (e.g. binary assets) you can stub them out with the "moduleNameMapper" config option.

    You'll find more details and examples of these config options in the docs:
    https://jestjs.io/docs/en/configuration.html

    Details:

    SyntaxError: test.ts: Unexpected token (8:27)

       6 | describe('SoMeWrapper', () => {
       7 |   it('matches snapshot', () => {
    >  8 |     expect(renderer.create(<SoMeWrapper />)).toMatchSnapshot();
         |                            ^
       9 |   });
      10 | });
      11 |

      at Parser.raise (node_modules/@babel/parser/lib/index.js:3834:17)
      at Parser.unexpected (node_modules/@babel/parser/lib/index.js:5142:16)
      at Parser.parseExprAtom (node_modules/@babel/parser/lib/index.js:6279:20)
      at Parser.parseExprSubscripts (node_modules/@babel/parser/lib/index.js:5848:23)
      at Parser.parseMaybeUnary (node_modules/@babel/parser/lib/index.js:5828:21)
      at Parser.parseExprOps (node_modules/@babel/parser/lib/index.js:5717:23)
      at Parser.parseMaybeConditional (node_modules/@babel/parser/lib/index.js:5690:23)
      at Parser.parseMaybeAssign (node_modules/@babel/parser/lib/index.js:5635:21)
      at Parser.parseExprListItem (node_modules/@babel/parser/lib/index.js:6930:18)
      at Parser.parseCallExpressionArguments (node_modules/@babel/parser/lib/index.js:6051:22)

Test Suites: 1 failed, 1 total
Tests: 0 total
Snapshots: 0 total
Time: 0.793s
Ran all test suites.
npm ERR! code ELIFECYCLE
npm ERR! errno 1
npm ERR! testing-preact@1.0.0 test: `jest`
```

This seems to be caused by the fact that it was in deed no plain TypeScript, it was using TSX.
I had to rename the file to `.tsx` in order for the test runner to understand TSX.

## Step #4 – Give Up

At this point it still did not run and I decided to give up.
Not entirely, but I decided to simply copy and paste my config from an existing project, where I had already used a notable amount of hours for setting things up.

Here is the configuration that I copied from another similar project to our `package.json`:

```json
  "scripts": {
    ...
    "pretest": "npm run lint",
    "test": "node scripts/tests.js",
    "no-watch-test": "node scripts/tests.js --no-watch"
  },
  "jest": {
    "globals": {
      "ts-jest": {
        "tsConfig": "tsconfig.jest.json"
      }
    },
    "transform": {
      "^.+\\.js$": "<rootDir>/node_modules/babel-jest",
      "^.+\\.tsx?$": "ts-jest"
    },
    "testMatch": [
      "**/__tests__/**/*.ts?(x)",
      "**/?(*.)+(spec|test).ts?(x)"
    ],
    "moduleNameMapper": {
      "^.+\\.css$": "identity-obj-proxy",
      "^(app/.+)$": "<rootDir>/src/$1/",
      "^(components/.+)$": "<rootDir>/src/$1/",
      "^(stores/.+)$": "<rootDir>/src/$1/",
      "^(views/.+)$": "<rootDir>/src/$1/",
      "^(assets/.+)$": "<rootDir>/src/$1/",
      "^(models/.+)$": "<rootDir>/src/$1/"
    },
    "moduleFileExtensions": [
      "ts",
      "tsx",
      "js",
      "jsx"
    ],
    "automock": false,
    "setupFiles": [
      "./scripts/setupJest.js"
    ]
  }
```

The `tests.js` file looks like this:

```js
process.env.NODE_ENV = 'test';
process.env.PUBLIC_URL = '';

const jest = require('jest');
const argv = process.argv.slice(2);
argv.push('--coverage');

// Watch unless --no-watch or running in CI
if (argv.indexOf('--no-watch') == -1 && !process.env.CI) {
  argv.push('--watchAll');
}

jest.run(argv);
```

It is basically a helper for passing some params to `jest`.

And the `setupJest.js` file looks like this:

```js
global.fetch = require('jest-fetch-mock');
```

Which is a helper for mocking fetch requests in tests.

Additionally, I had to install these dependencies:

```bash
npm i -D identity-obj-proxy preact-testing-library
```

## Step #5 – Try Again

Now with the copied configuration, we should be good to go, right?

The result looks like this:

```js
TypeError: getVersion is not a function
at buildArgv ([redacted]/node_modules/jest/node_modules/jest-cli/build/cli/index.js:399:5)
at Object.<anonymous> ([redacted]/node_modules/jest/node_modules/jest-cli/build/cli/index.js:243:20)
at Generator.next (<anonymous>)
at asyncGeneratorStep ([redacted]/node_modules/jest/node_modules/jest-cli/build/cli/index.js:202:24)
at \_next ([redacted]/node_modules/jest/node_modules/jest-cli/build/cli/index.js:222:9)
at [redacted]/node_modules/jest/node_modules/jest-cli/build/cli/index.js:227:7
at new Promise (<anonymous>)
at Object.<anonymous> ([redacted]/node_modules/jest/node_modules/jest-cli/build/cli/index.js:219:12)
at Object.\_run2 ([redacted]/node_modules/jest/node_modules/jest-cli/build/cli/index.js:265:16)
at Object.run ([redacted]/node_modules/jest/node_modules/jest-cli/build/cli/index.js:236:16)
npm ERR! code ELIFECYCLE
npm ERR! errno 1
npm ERR! testing-preact@1.0.0 test: `node scripts/tests.js`
npm ERR! Exit status 1
npm ERR!
npm ERR! Failed at the testing-preact@1.0.0 test script.
npm ERR! This is probably not a problem with npm. There is likely additional logging output above.

npm ERR! A complete log of this run can be found in:
npm ERR! /[redacted]/.npm/\_logs/2019-02-04T12_03_21_659Z-debug.log
NPM command npm run test -- failed with code 1
```

However, looking at the source code for jest-cli, it seems that `getVersion` is a function.
I decided to downgrade to version 23.1.0 of jest, since I knew it was used in another project.
Downgrading helped.

Now, we get this nice looking output and can continue adding more tests.

![Successful run of Jest](/images/jest/success.jpg)

## Step #6 – Additional Steps

It is recommended to setup a prepush hook for verifying that tests are passing before pushing to remote.

Read more in my [previous blog post](/blog/my-opinionated-setup-for-web-projects).
