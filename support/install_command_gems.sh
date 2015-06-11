haveProg() {
    $1 2>&1 > /dev/null
}

debian() {
  #apt-get update
  apt-get --no-install-recommends --assume-yes install ruby
}

fedora() {
  dnf -y install ruby rubygems
}

el() {
  yum -y install ruby rubygems
}

if haveProg "apt-get -h" ; then debian
elif haveProg "dnf -h" ; then fedora
elif haveProg "yum -h" ; then el
else
    echo "Your distribution is not yet supported."
    exit 2
fi
