require 'minitest/spec'

describe "wright::default" do

  it "has created /tmp/foo" do
    assert File.directory?("/tmp/foo")
  end
end

describe "wright::lib_include" do
  it "has created group ordinary_gentlemen" do
    group("ordinary_gentlemen").must_exist
  end
end
