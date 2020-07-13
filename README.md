# Weighted Round Robin
This module provides a round-robin algorithm for rotating elements according to differing weights, instead of evenly. It was inspired by the npm package [weighted-round-robin](https://www.npmjs.com/package/weighted-round-robin), and uses the same logic for its algorithm.

## Usage

The module tracks elements that you wish to distribute in a weighted round-robin rotation. They're added to the rotation as a struct that, at minimum, contains an `id` key with a unique identifier (though you'll probably also want to include a `weight`). If you like, the struct can contain other keys - a `name` for example.

It stores these elements, either in memory or in a cache, and returns the element struct when you call the module's `get()` method. These elements will be rotated and returned, according to their weight. Here's an example:

```cfc
rr = new path.to.weightedroundrobin.RoundRobin();

rr.add(
  {
    "id": "heavy",
    "weight": 6
  }
);

rr.add(
  {
    "id": "light",
    "weight": 3
  }
);

rr.add(
  {
    "id": "feather",
    "weight": 1
  }
);

// you can add as many as needed

for ( i = 0; i < 10; i++ ) {
  writeOutput( rr.get().id & '<br>' );
}
// heavy, light, heavy, heavy, light, heavy, feather, heavy, heavy, light
```

### Using Memory or a Cache
The default procedure for this module is to store the round-robin rotation in memory. You don't need to pass any arguments in when you `init` the component, and you should store it as a singleton (or in the application scope).

However, when you're deploying a distributed application (like Docker Swarm), or if you'd like more robust data persistence, you can configure the module to store/track the rotating elements in a remote cache (like Redis). *Note that remote caching engines are only available in Lucee or Adobe ColdFusion 2018*. 

To use this approach, `init` the component with a cache identifier you'd like the component to use for storing/retrieving the data and the name of the cache region it should use (this defaults to `object`). For example:

```cfc
rr = new path.to.weightedroundrobin.RoundRobin( 
  cacheId = '_roundrobinElements',
  cacheRegion = 'cache_region_name'
);
```

When using this approach, you don't necessarily need to store the RoundRobin component in a persistant scope, since the data is tracked/stored separately.

### Reference Manual

#### `init( string cacheId = '', string cacheRegion = 'object' )`
When the component is init with a `cacheId` and `cacheRegion`, the data will be stored in the specified cache, using the provided cacheId, instead of in the component memory, which is the default.

#### `add( required struct element, boolean overwrite = true )`
Adds an element to the round-robin rotation. Returns the element's key.

The `element` is a struct, with at minimum an `id` key, but if you're using this module, you'll likely also want a `weight` key. The default `weight` is 1, which will be used if no weight is provided.

By default, if you try to `add()` an element that already exists, it is ignored. If you want to overwrite the existing element, set the `overwrite` parameter to `true`.

#### `get()`
Returns the next element in the round-robin rotation. The full struct is returned.

#### `remove( required any key )`
Removes an element from the round-robin rotation.

#### `reset()`
Restores all elements in the round-robin rotation to their original weight, effectively restarting the rotation.

#### `wipe()`
Removes all elements from the rotation, leaving it empty.

#### `expose()`
Returns the round-robin rotation struct so you can see elements and their weights. Helpful for debugging.

#### `size()`
Returns the number of elements being tracked in the rotation.

#### `hasCache()`
Returns `true` or `false`, depending on if the component is using a cache for storing the data or not.

# Questions
For questions that aren't about bugs, feel free to hit me up on the [CFML Slack Channel](http://cfml-slack.herokuapp.com); I'm @mjclemente. You'll likely get a much faster response than creating an issue here.

# Contributing
:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

Before putting the work into creating a PR, I'd appreciate it if you opened an issue. That way we can discuss the best way to implement changes/features, before work is done.

Changes should be submitted as Pull Requests on the `develop` branch.