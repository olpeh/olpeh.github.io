---
title: 'Runtime Type Safety And More in TypeScript Projects Using io-ts'
date: 2019-02-08 00:00:00 Z
updated: 2019-02-10 00:00:00 Z
layout: post
excerpt: 'TypeScript will only bring you type checking on compile time, when compiling to JavaScript. On runtime, your code is JS and anything can happen. However, there is a solution to this problem.'
author: 'Olavi Haapala'
author_twitter: '0lpeh'
image: '/images/07-io-ts/fire.jpg'
altText: 'Fireman at work'
credits: 'Photo by Hush Naidoo on Unsplash'
---

# The Problem

TypeScript is absolutely helpful for avoiding the most common problems in JS projects, including `undefined is not a function` and `cannot read property <foo> of undefined`.
Most of the time, those happen because you have typoed something in your code, or you are using a library and don't know it's API correctly.
Typings will help you in spotting these problems and more.
You can model your data using interfaces or classes and make give type annotations to functions, so that the compiler will warn you if the return value of a function does not match the annotation.

An example where TypeScript compiler will help you:

```ts
interface User {
  id: number;
  username: string;
}

const getUserName = (user: User): string => user.id;

console.log(getUsername({ id: 1234, username: 'john@example.com' }));
```

In this case, you would see the following error:

```ts
[ts] Type 'number' is not assignable to type 'string'. [2322]
(parameter) user: User
```

And hopefully your editor will also highlight the problem to you immediately.

However, there are situations where TypeScript is not able to help you.
Those can be also on compile time but more critically they happen on runtime.
On runtime, your code is JavaScript and basically everything is of type `any`.
As an example, what would happen if your api endpoint for returning the user information would return:

```
{ id: "1234", name: false }
```

Which would not match your `User interface` in TypeScript.
However, your code would try to run until at some point it might crash.
This is frustrating.

## A Solution

I had heard many people recommend using [io-ts](https://github.com/gcanti/io-ts){:target="\_blank"}{:rel="noopener"} for tackling this problem.
Last Friday I tried it for the first time and my mind was blown.

[![Me Tweeting about how I felt using io-ts for the first time.]({{ "/images/07-io-ts/io-ts-tweet.png" | prepend: site.baseurl }})](https://twitter.com/0lpeh/status/1091343933551140864){:target="\_blank"}{:rel="noopener"}

With `io-ts`, you are able to validate types during runtime.
I'm not an expert on this topic yet, but here is an example of how we currently use it in our project.

`models/District.ts`:

```ts
import * as t from 'io-ts';

export type District = t.TypeOf<typeof TDistrict>;

export const TDistrict = t.type({
  id: t.number,
  name: t.string
});

/*
 Which would be equivalent to the following TS interface:
export interface District {
  id: number,
  name: string
};
*/
```

The type `District` is an alias so that we don't have to pass around the type:

```ts
const District: t.TypeC<{
  id: t.NumberC;
  name: t.StringC;
}>;
```

Instead we now have:

```ts
type District = {
  id: number;
  name: string;
};
```

And then when fetching `District`s from the backend, we are able to validate those against the schema:

```ts
// res is the response we got from the backend
const validDistricts = res
  .map((q) => TDistrict.decode(q))
  .filter((v) => {
    if (v.isLeft()) {
      console.warn('District validation failed', PathReporter.report(v));
      return false;
    }
    return v.isRight();
  })
  .map((q) => q.value as District);
console.log('Valid districts from the backend are ', validDistricts);
```

Where `PathReporter` is a utility provided by the library for nicely outputting the failed validation.

`TDistrict.decode` returns a `Validation<TDistrict>` which looks like this:

```ts
export declare type Validation<A> = Either<Errors, A>;
```

This means it can either hold an error in Left or the successfully validated value in Right.
This is cool.

## Option Types in TypeScript

Then, yesterday I was writing some code and implemented a function that would return a `District` by its id.
The id could of course be invalid and not found in the list of `District`s.
So, this means the return value of my function `getDistrictById` is `Option<District>`, which means it can return a `District` or nothing in case it's not found.

Sadly, I thought, we don't have `Option` in TS.
However I just typed out the type annotation there and my editor suggested to `import { Option } from 'fp-ts/lib/Option'`.
Oh wow!
My mind was blown again.

So, my function definition looks like this:

```ts
const getDistrictByID = (districtId: number): Option<District>
```

And when calling it, I would check the return value like this:

```ts
import { Option, none, some } from 'fp-ts/lib/Option';

const districtOption: Option<District> = districtStore.getDistrictByID(
  districId
);

if (districtOption.isSome()) {
  // districtOption now has a value
} else {
  // districtOption is none
}
```

### Missing Pieces

So, now the only missing piece is pattern matching.
I mean, it would be nice to have something like this in TS:

```ts
districtOption match {
  case some(district: District) => console.log('Do something with the district')
  case _ => console.warn(`District with id ${districtId} was not found`)
}
```

Or maybe there is a solution for that in `io-ts` or in some other library that I just haven't discovered yet?
Please let me know.

## Update: Pattern Matching Using io-ts

As the author of io-ts helpfully pointed out, there is a way to do pattern matching with io-ts.
It can be done using `fold` or `foldL`, which is the lazy version of fold.

[![The author of io-ts tweeting me how to do pattern matching.]({{ "/images/07-io-ts/pattern-matching.png" | prepend: site.baseurl }})](https://twitter.com/GiulioCanti/status/1093874633269526528){:target="\_blank"}{:rel="noopener"}

So, my example using `foldL` looks like this, then:

```ts
districtOption.foldL(
  () => console.warn(`District with id ${districtId} was not found`),
  (district) => console.log(`Do something with the district ${district.name}`)
);
```

Amazing!
