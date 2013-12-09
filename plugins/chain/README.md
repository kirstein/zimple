# #chain

## Lazy chaining of Z plugins.

Chain makes it possible to easily chain together all predefined Z plugins (that allow chaining).  

```
    Z(<context>).chain(). ... .value()
    Z.chain(<context>). ... .value()
```

Links in chain are completely lazy. They will be evaluate only when the result is called.

## What you can and cant do

You cant chain together plugins that:

1. register themselves with `chain = false` option
2. happen to have the name of `value`

All other defined plugins are chain-able. Go nuts!

## How it works

When the `result` of a chain is called then all chain links, starting from the first will be evaluated.  
Each next link will receive the context of the previous links return value.

__Example:__

```
    Z.fn('double', function(val) { return val * 2 });
    Z.fn('sum', function(list) { 
      return list.reduce(function(a, b) {
        return a + b;
      });
    });
    
    alert(Z.chain([1,3,5]).sum().double().value())   // 18
    alert(Z([1,3,5]).chain().sum().double().value()) // 18
```
[jsfiddle demo](http://jsfiddle.net/4wSDM/)

## API

1. `#chain(<context>)` will start the chain on given context (first member will be called with this context)
2. `#value()` returns the value of a current chain, evaluating all chains links.

## Options

List of options given to Z while registering the `chain` plugin:

1. chain = false 