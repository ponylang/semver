// in your code this `use` statement would be:
// use "semver/version"
use "../../semver/version"

actor Main
  new create(env: Env) =>
    let v1 = Version(1, 2, 3)
    let v2 = ParseVersion("1.2.4")
    if (v2 > v1) then
      env.out.print("You'd do something here!")
    end

    let v3 = ParseVersion("1.2.3-1nv$l1d.prerel.f13ld$")
    if (not v3.is_valid()) then
      env.out.print("You'd do something here too!")
    end

    env.out.print(v1.string()) // => "1.2.3"
