# semver

A semantic versioning library and constraints solver for Ponylang heavily inspired by [blang/semver](https://github.com/blang/semver).

## Installation

## Installation

* Install [corral](https://github.com/ponylang/corral)
* `corral add github.com/ponylang/semver.git`
* `corral fetch` to fetch your dependencies
* Include any of the available packages...
  * `use "semver/range"`
  * `use "semver/solver"`
  * `use "semver/version"`
* `corral run -- ponyc` to compile your application

## Usage

```pony
use "semver/version"

actor Main
  new create(env: Env) =>
    let v1 = Version(1, 2, 3)
    let v2 = ParseVersion("1.2.4")
    if (v2 > v1) then
      // do something
    end

    let v3 = ParseVersion("1.2.3-1nv$l1d.prerel.f13ld$")
    if (not v3.is_valid()) then
      // do something
    end

    env.out.print(v1.string()) // => "1.2.3"
```

For usage of ranges / the solver see the test code for now.
