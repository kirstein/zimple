# #once

## Call a wrapped function only once.
---
Once makes it easy to make functions callable only once.

```
    Z(<function>).once()
    Z.once(<function>)
```

## How it works
---

When wrapping a function with `once` it will return a new wrapped function that saves its return value after the first call. Every call after that will be ignored and the first calls result will be returned instead.

__Example:__

```
    function yello(name) {
        alert('hello! ' + name);
    };
    
    var wrapped = Z(yello).once();
    wrapped('paul'); // will alert 'hello paul'
    wrapped('jack'); // nothing...
    
    var wrapped2 = Z.once(yello);
    wrapped2('jill'); // will alert 'hello jill'
    wrapped2('bill'); // nothing...
```

[jsfiddle demo](http://jsfiddle.net/NhGX3/)

## API
---

1. `#once(<function>)` returns a wrapped function

## Options
---

List of options given to Z while registering the `once` plugin:

1. chain = false 