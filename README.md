# Weighted Round Robin
This module provides a round-robin algorithm for rotating elements according to differing weights, instead of evenly.

## Usage

## Reference Manual

|                          Method                          |                              Description                               |
| -------------------------------------------------------- | ---------------------------------------------------------------------- |
| `add(required struct element, boolean overwrite = true)` | Add an element to the round-robin rotation. Returns the element's key. |
| `remove(required any key)`                               | Remove an element from the round-robin rotation                        |
| `reset()`                                                |                                                                        |
| `wipe()`                                                 |                                                                        |
| `get()`                                                  |                                                                        |
| `expose()`                                               |                                                                        |
| `size()`                                                 |                                                                        |
| `hasCache()`                                             |                                                                        |
| `init()`                                                 |                                                                        |

### Acknowledgements

This project was inspired by the npm package [weighted-round-robin](https://www.npmjs.com/package/weighted-round-robin).