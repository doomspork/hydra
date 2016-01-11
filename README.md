# Hydra [![License][license-img]][license]

[license-img]: https://img.shields.io/badge/license-Apache%202.0-blue.svg
[license]: http://opensource.org/licenses/Apache-2.0

> A multi-headed beast: API gateway, request cache, and data transformations.

## Requirements

1. Erlang 18
1. Elixir 1.1

  ```shell
  $ brew install elixir
  ```

## Instructions

1. Clone project:

  ```shell
  $ git clone git@github.com:doomspork/hydra.git
  ```

1. Install dependencies:

  ```shell
  $ cd hydra
  $ mix deps.get
  ```

1. Run tests:

  ```shell
  $ mix test
  ```

1. Build Escript:

  ```shell
  $ mix escript.build
  ```

1. Run application:

  ```shell
  $ ./hydra
  ```
