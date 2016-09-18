#!/bin/bash

# Installs/Updates Ruby, RVM, GPG, GCC, Brew, Java, Rake, Bundle, Postgres, Redis
# Also all the rails gems in example_rails_app
#
# Dependencies are for running a Selenium Server and a Rails app

RUBY_VERSION="2.3.0"
RVM_GPG_KEY="409B6B1796C275462A1703113804BB82D39DC0E3"

#Install xCode Command Line Tools
if [ ! -f "/usr/local/bin/gcc-4.2" ]; then
  xcode-select --install
fi

#Link GCC
ln -s /usr/bin/gcc /usr/local/bin/gcc-4.2

#Install Brew
if which brew >/dev/null; then
  echo "Updating Brew"
  brew update
else
  echo "Installing Brew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew tap caskroom/cask

#Install GPG
if which gpg >/dev/null; then
  echo "Updating GPG"
  brew upgrade gpg
else
  echo "Installing GPG"
  brew install gpg
fi

#Install RVM
if which rvm >/dev/null; then
  echo "Updating RVM"
  gpg --keyserver hkp://keys.gnupg.net --recv-keys $RVM_GPG_KEY
  rvm get head
else
  echo "Installing RVM"
  gpg --keyserver hkp://keys.gnupg.net --recv-keys $RVM_GPG_KEY
  \curl -sSL https://get.rvm.io | bash -s stable --ruby=$RUBY_VERSION
fi

#Install Ruby
if which ruby >/dev/null; then
  echo "Installing Ruby"
  rvm install $RUBY_VERSION
else
  #Check version if not then update
  if ruby -v | grep $RUBY_VERSION >/dev/null; then
    echo "Ruby Version up to date!"
  else
    #Already exists in list, then use version, otherwise install
    if rvm list | grep $RUBY_VERSION >/dev/null; then
      echo "Ruby exists already, will end up using it below"
      rvm use $RUBY_VERSION
    else
      echo "Installing Ruby"
      rvm install $RUBY_VERSION
    fi
  fi
fi

#Set Ruby version to current and update dot files in home dir
rvm use $RUBY_VERSION
rvm get stable --auto-dotfile

#Install Gems

#Install Rake
if which rake >/dev/null; then
  echo "Updating Rake"
  gem update rake
else
  echo "Installing Rake"
  gem install rake
fi

#Install Bundle
if which bundle >/dev/null; then
  echo "Updating Bundle"
  gem update bundler
else
  echo "Installing Bundle"
  gem install bundler
fi

#Install Postgres + Redis
if which postgres >/dev/null; then
  echo "Updating Postgres"
  brew upgrade postgres
else
  echo "Installing Postgres"
  brew install postgres
fi

if which redis-server >/dev/null; then
  echo "Updating Redis"
  brew upgrade redis
else
  echo "Installing Redis"
  brew install redis
fi

cd example_rails_app/
bundle
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
cd ../

echo "Done"