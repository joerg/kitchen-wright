require 'wright'

foo_dir = Wright::Resource::Directory.new('/tmp/foo')
foo_dir.create
fstab = Wright::Resource::Symlink.new('/tmp/foo/fstab')
fstab.to = '/etc/fstab'
fstab.create

# There seems to be a bug in wright:
# https://github.com/sometimesfood/wright/issues/11
require './lib/wright_include'
