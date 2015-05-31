haveProg() {
    $1 2>&1 > /dev/null
}

debian() {
  #apt-get update
  apt-get --no-install-recommends --assume-yes install ruby
}

el() {
  yum -y install ruby rubygems rubygem-rake
  gem install rake --no-ri --no-rdoc #Needed on centos7
}

if haveProg "apt-get -h" ; then debian
elif haveProg "yum -h" ; then el
else
    echo "Your distribution is not yet supported."
    exit 2
fi
