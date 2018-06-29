<img src="https://www.cloudbolt.io/wp-content/uploads/CloudBolt_hlogo_blue_cloud_w_text2-1.png" width="500">

# Summary
This is a Chef Test Kitchen driver for CloudBolt.  It requires the Ruby api client.

## Build

```
$ gem build kitchen-cloudbolt.gemspec
```

## Install

```
$ gem install kitchen-cloudbolt-{VERSION}.gem
```

## Usage

### Environment Variables
```
Shell
$ export CLOUDBOLT_HOST=<hostname>
$ export CLOUDBOLT_USER=<username>
$ export CLOUDBOLT_PASS=<password>

Ruby
ENV['CLOUDBOLT_HOST'] = "hostname"
ENV['CLOUDBOLT_USER'] = "username"
ENV['CLOUDBOLT_PASS'] = "passowrd"
```

### Config File
See kitchen.yml for sample config

## LICENSE
This project is licensed under the terms of the MIT license located in LICENSE.md.

## CONTRIBUTING

By contributing to this project, you are agreeing to release your contributions under the MIT License.
