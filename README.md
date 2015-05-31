# Kitchen provisioner for wright

This is a  very, very, __VERY__ early development version. Use at your own risk.

# HowTo

Look at example folder and kick me for writing more documentation.
Some commands you may find helpful

```bash
cd example
cat .kitchen.yml
bundle install --path .bundle
bundle exec kitchen test default-debian-80
bundle exec kitchen create default-debian-80
bundle exec kitchen converge default-debian-80
bundle exec kitchen verify default-debian-80
bundle exec kitchen login default-debian-80
```

The default-debian-80 is actually a <suite>-<platform_name>. The suite and platform_name come from the .kitchen.yml, and in platform_name any special characters are removed.

# TODO

* Add install methods for :package, :packagecloud?, :bundler
* Add guards so wright, ruby etc. won't get installed every run
* Have wrightfile work in suite part of .kitchen.yml
* Add tests
* Get bug in busser fixed: https://github.com/test-kitchen/busser-serverspec/issues/28
  * Get CentOS, Fedora busser tests running
* Talk to @sometimesfood about patterns of files/directories
* Get GEM published
