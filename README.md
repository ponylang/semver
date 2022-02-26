# semver

A semantic versioning library and constraints solver for Ponylang heavily inspired by [blang/semver](https://github.com/blang/semver).

## Status

Beta

## Installation

* Install [corral](https://github.com/ponylang/corral)
* `corral add github.com/ponylang/semver.git --version 0.2.4`
* `corral fetch` to fetch your dependencies
* Include any of the available packages...
  * `use "semver/range"`
  * `use "semver/solver"`
  * `use "semver/version"`
* `corral run -- ponyc` to compile your application

## Usage

See [examples](examples/) and the [ranges/solver](semver/test/) test code.

## API Documentation

[https://ponylang.github.io/semver](https://ponylang.github.io/semver)
