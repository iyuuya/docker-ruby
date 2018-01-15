FROM amazonlinux:latest
MAINTAINER iyuuya <i.yuuya@gmail.com>

ARG RUBY_VERSION=2.5.0

# Install dependencies, rbenv and ruby-build
RUN set -ex && \
    \
    deps=' \
      git \
      gcc \
      bzip2 \
      openssl-devel \
      readline-devel \
      zlib-devel \
      gdbm-devel \
      ncurses-devel \
      libffi-devel \
      libyaml-devel \
    ' && \
    yum -y update && \
    yum -y install $deps && \
    \
    git clone https://github.com/rbenv/rbenv.git /usr/local/rbenv && \
    git clone https://github.com/rbenv/ruby-build.git /usr/local/rbenv/plugins/ruby-build && \
    \
    { \
      echo 'install: --no-rdoc --no-ri --no-document'; \
      echo 'update: --no-rdoc --no-ri --no-document'; \
    } >> /usr/local/rbenv/gemrc && \
    { \
      echo 'export RBENV_ROOT=/usr/local/rbenv'; \
      echo 'export PATH=$RBENV_ROOT/bin:$PATH'; \
      echo 'export GEMRC=$RBENV_ROOT/gemrc:$GEMRC'; \
      echo 'eval "$(rbenv init -)"'; \
    } >> /etc/profile.d/rbenv.sh

# Install ruby $RUBY_VERSION
RUN source /etc/profile.d/rbenv.sh; \
    rbenv install $RUBY_VERSION; \
    rbenv global $RUBY_VERSION; \
    gem update --system; \
    gem install bundler --force
