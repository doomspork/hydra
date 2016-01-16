# Hydra

[![Build Status][travis-img]][travis] [![Hex Version][hex-img]][hex] [![License][license-img]][license]

[travis-img]: https://travis-ci.org/doomspork/hydra.png?branch=master
[travis]: https://travis-ci.org/doomspork/hydra
[hex-img]: https://img.shields.io/hexpm/v/hydra.svg
[hex]: https://hex.pm/packages/hydra
[license-img]: https://img.shields.io/badge/license-Apache%202.0-blue.svg
[license]: http://opensource.org/licenses/Apache-2.0

> A multi-headed beast: API gateway, request cache, and data transformations.

Hydra's goal is to be a distributable and fault tolerant API gateway with integrated cache and support for data transformations.  Community involvement and contributions are welcomed and encouraged.

___There isn't much to see here yet, Hydra is still under active development___

## Getting Started

Hydra is built with Elixir 1.2 and will not work with earlier versions.  For data transformations we rely on the powerful [jq][jq] command-line JSON processor.  Please see the [jq][jq] website for instructions on installing for your system.

[jq]: https://github.com/stedolan/jq

1. Clone project:

  ```shell
  $ git clone git@github.com:doomspork/hydra.git
  $ cd hydra
  ```

1. Install dependencies:

  ```shell
  $ mix deps.get
  ```

1. Verify tests pass:

  ```shell
  $ mix test
  ```

1. Finally, we have two options for running Hydra:

  - Start an instance with Mix:

  		```shell
  		$ mix hydra
  		```
  
  - Or build and run an executable with escript:
  
  		```shell
  		$ mix build
  		$ ./hydra
  		```

## Learn More

1. [Pattern: API Gateway][1]
1. [Inside the Netflix API Redesign][2]
1. [jq Manual][3]

[1]:http://microservices.io/patterns/apigateway.html
[2]:http://techblog.netflix.com/2012/07/embracing-differences-inside-netflix.html
[3]:https://stedolan.github.io/jq/manual/
 
## Contributing

Contributions are always welcome.  We ask that contributors familiarize themselves with the [CONTRIBUTING.md](CONTRIBUTING.md) guide.

## License

Hydra source code is released under Apache 2.0 License.

See [LICENSE](LICENSE) for more information.
