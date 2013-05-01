# Huggy Bear

![](./huggy.jpg)

> Huggy was so cool he owned an iPad in the 70s!

## What it does

HuggyBear does "silent mixin". It creates and stores functionnality for any object without never __ever__ needing to compromise their structure or properties.

## An example

Suppose an instance of the `People` prototype, with 3 methods: `walk`, `sleep`, `work` (_very limited, huh?_).

Now you want the instances of `People` to be also instances of `EventEmitter`, you'll have to add `on`, `off`, `emit`.

And now, you want the instances of `People` to do `PubSub`, then you add `publish` and `subscribe`.

### So what ?

So your handfully crafted `People` prototype, in the pure and beautiful simplicity of its 3 methods, has just lost its essence and is now
a kind of a hydra with 8 methods, namely `walk`, `sleep`, `work`, `on`, `off`, `emit`, `publish`, `register`.

__HuggyBear__ will keep your models sane and simple.

## Some code, please

    var huggyBear = require('huggybear');

    function People () {
      huggyBear.provide(this, '/path/to/mixins/EventEmitter' /*, mixinArg1, mixinArg2 */);
    }

    People.prototype = {
      walk: function () {},
      sleep: function () {},
      work: function () {}
    }

    var ppl = new People();
    ppl.on('eventName', function () {}); // throws TypeError, obviously
    pplEventEmitter = huggyBear.claim('/path/to/mixins/EventEmitter');
    pplEventEmitter.on('eventName', function () {}); //OK

> You don't have to use the prototypal inheritance for HuggyBear to work. It's just that I'm kind of old fashioned, in some way.
>
> You don't even have to put it in the constructor, of course. Add functionnality whwnever you need to.

## Building a mixin

To build a mixin, you must build a CommonJS module which `exports` __MUST__ be a function.
it can take any number of parameters, you will pass them by appending parameters to `huggyBear#provide`.

In other words, the `exports` of your module is the generator (_aka_ the factory) of your mixin.

### An exemple for a mixin of `EventEmitter`

    var EventEmitter = require('events').EventEmitter;

    module.exports = function () {
      return new EventEmitter();
    };

For every object that wants this mixin to be provided, an instance of `Emitter` is created.
Each object get its own instance.

Simple.

## Using HuggyBear globally

You may want to bring `HuggyBear` to every object...

    var huggyBear = require('huggybear');

    Object.prototype.provide = function (/*name, arg1, arg2 */) {
      return huggyBear.provide.apply(undefined, [this].concat(Array.prototype.slice.call(arguments)));
    }

    Object.prototype.claim = function (/*name*/) {
      return huggyBear.claim.apply(undefined, [this].concat(Array.prototype.slice.call(arguments)));
    }

## Testing

The tests and coverage reports are available in the [TESTING](./TESTING) file.

## License

MIT
