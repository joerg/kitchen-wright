require 'minitest/autorun'

describe "wright::default" do

  it "has created /tmp/foo" do
    assert File.directory?("/tmp/foo")
  end
end
