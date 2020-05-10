# semver

A semantic versioning library and constraints solver for Ponylang heavily inspired by [blang/semver](https://github.com/blang/semver).

## Status

[![Actions Status](https://github.com/ponylang/semver/workflows/vs-ponyc-latest/badge.svg)](https://github.com/ponylang/semver/actions)

Beta

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

See [examples](examples/) and the [ranges/solver](semver/test/) test code.
