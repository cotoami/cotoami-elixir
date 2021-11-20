FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q
RUN apt-get -y install build-essential language-pack-ja openssl libssl-dev ncurses-dev curl git

# Locale
RUN update-locale LANG=ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# Node.js
RUN apt-get -y install rlwrap && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y --force-yes nodejs

# Erlang and Elixir
RUN curl -o /tmp/erlang.deb http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
    dpkg -i /tmp/erlang.deb && \
    rm -rf /tmp/erlang.deb && \
    apt-get update -q

RUN apt-cache show esl-erlang && apt-cache show elixir

RUN apt-get install -y esl-erlang=1:20.3.8.21-1 && \
    apt-get install -y elixir=1.7.4-1 && \
    apt-get clean -y

RUN mix local.hex --force && mix local.rebar --force
