# Kitchen provisioner for wright

kitchen-wright is a kitchen provisioner for [wright](https://github.com/sometimesfood/wright). Its intention is to simplify testing your wright-scripts on different distributions and with different setups. All you need is a Gemfile and a .kitchen.yml.
This is a  very, very, __VERY__ early development version. Use at your own risk.

# HowTo

Look at example folder and kick me for writing more documentation.
Some commands you may find helpful

```bash
cd example
cat .kitchen.yml
bundle install --path .bundle --gemfile Gemfile.kitchen --binstubs
bin/kitchen test default-debian-80
bin/kitchen create default-debian-80
bin/kitchen converge default-debian-80
bin/kitchen verify default-debian-80
bin/kitchen login default-debian-80
```

The ```default-debian-80``` is actually a ```<suite>-<platform_name>```. The suite and platform_name come from the .kitchen.yml, and in platform_name any special characters are removed.

# .kitchen.yml

## Configuration

All config can be set in provisioner and suites. Since kitchen is quite static when it comes to suites they currently have to be under ```attributes```. I hope this can be changed, but for now it will do.

### install_method

Default: bundler_local
Allowed values: bunlder_local, bunlder_global (package, bundle will be supported in future versions)
Examples:

```
provisioner:
  name: wright
  install_method: bundler_local
```

```
suites:
  name: any
  attributes:
    install_method: bundler_global
```

### wrightfile

The file that will be exectuted with ```wright WRIGHTFILE```.

Default: wright.rb
Allowed values: any local path
Examples:
```
provisioner:
  name: wright
  wrightfile: my_wright.rb
```

```
suites:
  name: any
  attributes:
    wrightfile: lib/my_wright.rb
```

### log_level

Default: none
Allowed values: quiet, verbose
Example:
```
provisioner:
  log_level: verbose
```

### dry_run

Default: false
Allowed values: true, false
Example:
```
provisioner:
  dry_run: true
```

## Full Example

A full .kitchen.yml could look like this (see also example folder):

```
---
driver:
  name: docker_cli

transport:
  name: docker_cli

provisioner:
  name: wright
  install_method: gems
  wrightfile: my_wrightfile.rb

verifier:
  ruby_bindir: /usr/bin

platforms:
  - name: debian-8.0
    driver_config:
      image: debian:jessie
  - name: ubuntu-15.04
    driver_config:
      image: ubuntu:15.04
  - name: centos-7
    driver_config:
      image: centos:centos7
  - name: fedora-22
    driver_config:
      image: fedora:22

suites:
  - name: default
    attributes:
      wrightfile: lib/wright_include.rb
```

For driver and transport see the according ```kitchen-docker_cli``` gem.

# Gotcha!

If you have tests you have to set the ```ruby_bindir``` of verifier, because it will by default use chefs (```/opt/chef/embedded/bin```) ruby. Just add the following to your .kitchen.yml:
```
verifier:
  ruby_bindir: /usr/bin
```

When working with the serverspec or minitest test suites of kitchen you may have to include a Gemfile which installs rake. This is a dependency that comes with ruby on many, but not all systems. See example folder for further details.

By default kitchen-wright will create a Gemfile for your to install wright. If you already have a Gemfile, kitchen-wright will use this one and install (--without development) all specified Gems.

# TODO

* Add guards so wright, ruby etc. won't get installed every run
* Add tests
* Hide all unnecessary shell output
* Get GEM published
