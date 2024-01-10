FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q
RUN apt-get -y install build-essential language-pack-ja openssl libssl-dev ncurses-dev curl git

# Locale
RUN update-locale LANG=ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# Node.js
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.16.0
RUN mkdir -p $NVM_DIR && \
    curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default && \
    npm install -g yarn
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Erlang and Elixir
RUN curl -o /tmp/erlang.deb https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && \
    dpkg -i /tmp/erlang.deb && \
    rm -rf /tmp/erlang.deb && \
    apt-get update -q

# Uncomment the following line if you want to check out the available packages in erlang/elixir
# RUN apt-cache show esl-erlang && apt-cache show elixir

RUN apt-get install -y esl-erlang=1:22.3.4.9-1 && \
    apt-get install -y elixir=1.10.4-1 && \
    apt-get clean -y

RUN mix local.hex --force && mix local.rebar --force
