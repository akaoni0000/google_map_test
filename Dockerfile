FROM ruby:2.5.7

RUN apt-get update -qq && apt-get install -y build-essential nodejs vim

RUN mkdir /googlemap
WORKDIR /googlemap

# ホストのGemfileとGemfile.lockをコンテナにコピー
COPY Gemfile /googlemap/Gemfile
COPY Gemfile.lock /googlemap/Gemfile.lock

# bundle installの実行
RUN bundle install

# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
COPY . /googlemap

# puma.sockを配置するディレクトリを作成
RUN mkdir tmp/sockets