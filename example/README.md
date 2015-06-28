# What this is

This is a simple example of kitchen-wright. To customize, check out the .kitchen.yml.

# HowTo

To try this example, You need a working docker install accessible as user.

```bundle install --path .bundle --gemfile Gemfile.kitchen --binstubs```

to install the kitchen dependencies into .bundle.

```bin/kitchen test debian-80```

to run both suites (default and special) for debian-80.
