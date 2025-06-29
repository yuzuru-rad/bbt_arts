FROM ruby:3.3.4-slim

ENV DEBIAN_FRONTEND=noninteractive

# 基本ツールとNode.js / Yarnの導入
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  libpq-dev \
  postgresql-client \
  curl \
  gnupg \
  git \
  file \
  imagemagick \
  && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g yarn \
  && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリ
WORKDIR /var/www/app

# Gemfileだけ先にコピーして bundle install（キャッシュ活用）
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# アプリ全体をコピー
COPY . .

# 起動スクリプトを実行可能に
COPY web-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/web-entrypoint.sh

ENTRYPOINT ["web-entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
