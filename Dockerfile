FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libreadline-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L -R -O https://www.lua.org/ftp/lua-5.5.0.tar.gz && \
    tar zxf lua-5.5.0.tar.gz && \
    cd lua-5.5.0 && \
    make linux && \
    make install && \
    cd .. && \
    rm -rf lua-5.5.0 lua-5.5.0.tar.gz

RUN apt update && apt install -y \
    luarocks \
    lua-socket \
    lua-sec \
    zlib1g-dev

RUN luarocks install telegram-bot-lua
RUN luarocks install lua-http
RUN luarocks install lua-cjson
RUN luarocks install ltn12 htmlparser
RUN luarocks install htmlparser

WORKDIR /app
COPY . .



CMD ["lua", "telegram-teste.lua"]