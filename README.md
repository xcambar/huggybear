# Huggy Bear

![](./huggy.jpg)

> Huggy was so cool he owned an iPad in the 70s!

## What it does

> TL;DR; Mixins without the mess

HuggyBear helps you add behaviour to your objects (typically model instances) without compromising their public signatures.

## Status

[![Codeship Status for xcambar/huggybear](https://www.codeship.io/projects/721a51e0-c901-0130-f9d1-72c77f53de0a/status?branch=master) ](https://www.codeship.io/projects/4795)
[![Coverage Status](https://coveralls.io/repos/xcambar/huggybear/badge.png)](https://coveralls.io/r/xcambar/huggybear)


## An example

Suppose an instance of the `People` prototype, with 3 methods: `walk`, `sleep`, `work` (_very limited, huh?_).

Now you want the instances of `People` to be also instances of `EventEmitter`, you'll have to add `on`, `off`, `emit`.

And now, you want the instances of `People` to do `PubSub`, then you add `publish` and `subscribe`.

### So what ?

So your handcrafted `People` that originally contains 3 methods, has just lost its essence and is now
a kind of a hydra with 8 methods, namely `walk`, `sleep`, `work`, `on`, `off`, `emit`, `publish`, `register`.

__HuggyBear__ helps keeping your models sane and simple.

## Some code, please

````javascript
var huggyBear = require('huggybear')();

function People () {
  huggyBear.provide(this, 'EventEmitter', new EventEmitter());
}

People.prototype = {
  walk: function () {},
  sleep: function () {},
  work: function () {}
}

var ppl = new People();
// They following will throw a TypeError, obviously
ppl.on('eventName', function () {});

//This is the HuggyBear way:
pplEventEmitter = huggyBear.claim('EventEmitter');
pplEventEmitter.on('eventName', function () {}); //OK
````

> Of course, thos will work with any object
>
> You don't have to put it in the constructor, of course.
> You're free to add functionnality whenever you need to.

# Tips on using huggyBear

## HuggyBear everywhere

You may want to bring `HuggyBear` to every object...

````javascript
var huggyBear = require('huggybear')();

Object.prototype.provide = function (name, definition) {
  return huggyBear.provide.apply(undefined, [this].concat(Array.prototype.slice.call(arguments)));
}

Object.prototype.claim = function (/*name*/) {
  return huggyBear.claim.apply(undefined, [this].concat(Array.prototype.slice.call(arguments)));
}
````

## License

MIT
