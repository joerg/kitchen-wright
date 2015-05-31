require 'serverspec'

set :backend, :exec

describe file('/tmp/foo/fstab') do
  it { should be_file }
end
