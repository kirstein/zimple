# Zimple [![Build Status](https://travis-ci.org/kirstein/zimple.png)](https://travis-ci.org/kirstein/zimple) [![Coverage Status](https://coveralls.io/repos/kirstein/zimple/badge.png)](https://coveralls.io/r/kirstein/zimple)

> A lightweight utility belt

## Concept

`Zimple` or `Z` is an utility belt for `JavaScript` developers. It is a versatile and simple way to handle small pieces of reusable code (or plugins) in your application.  

`Z` has a beautiful `jQuery-like` making it simple and easy to use its plugins.

## Goal

The goal of this project is to be a good experience for me about JS optimization.  
In all honestly I would not recommend using `Zimple`. Use something like `lodash` instead.

## Plugins

View the list of plugins from [here](https://github.com/kirstein/zimple/tree/master/plugins)
The plugin list is small at the moment, but with any luck its going to grow.

## API

1. `#fn('plugin name', pluginFn, [options])` registers `Z` plugin  
    Options are optional. By default they are set as empty object.


## Usage
#### using plugins

There are three designed ways to use `Z` plugins.

1. direct call
2. wrapped call
3. calling from another plugin

##### direct call:

Directly calling a plugin from Z. The first parameter of the call is considered to be the `context` and all additional parameters will be considered as `arguments`.

```
    Z.fn('sum', function(context, args) { return context + args });
    Z.sum(1, 2); // 3
    Z.sum(5, 8); // 13
```

##### wrapped call:
Wrapping means that the context value will be wrapped in `Z`.
This means that all the function call parameters will be passed in to the plugin after the `context` parameter.

```
    Z.fn('sum', function(context, args) { return context + args });
    Z(1).sum(2); // 3
    Z(5).sum(8); // 13
```

##### calling from another plugin:

Calling from inside plugins with `this` keyword means that the original plugin will be directly called. No context prepending will happen in this case.

```
    Z.fn('sum', function(a, b) { return a + b });
    Z.fn('sumArray', function(arr) { return arr.reduce(this.sum); });
    Z([1,5,6]).sumArray() // 12
    Z.sumArray([1,5,6]) // 12
```


## Creating plugins

Plugin creation is extremely easy with `Z`. All you need to do is to register your plugin via `#fn` method. This registers the plugin globally for `Z` and ca be instantly used.

There are no safety measurements taken to preserve predefined plugins, meaning that its very easy to overwrite previously defined plugins.

```
    Z.fn('sum', function(a, b) { return a + b });
```

In case any plugins need extra information about previously registered plugins, then there is also an option to register plugin specific `options`.

```
    Z.fn('sum', function(a, b) { return a + b }, { option : 'value' });
```

Options can be received from `Z.prototype.__plugins`


## Licence

MIT
