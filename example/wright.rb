require 'wright'

foo_dir = Wright::Resource::Directory.new('/tmp/foo')
foo_dir.create
fstab = Wright::Resource::Symlink.new('/tmp/foo/fstab')
fstab.to = '/etc/fstab'
fstab.create

require './lib/wright_include'
