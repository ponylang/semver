# pony-semver

A semantic versioning library for Ponylang heavily inspired by [blang/semver](https://github.com/blang/semver).

## Usage

```pony
use "semver"

actor Main
  new create(env: Env) =>
    let v1 = Version(1, 2, 3)
    let v2 = ParseVersion("1.2.4")
    if (v2 > v1) then
      // do something
    end

    let v3 = ParseVersion("1.2.3-1nv$l1d.prerel.f13ld$")
    if (not v3.isValid()) then
      // do something
    end

    env.out.print(v1) // => "1.2.3"
```
