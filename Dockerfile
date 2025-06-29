FROM ruby:3.3.4-slim as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  libpq-dev \
  nodejs \
  curl \
  gnupg \
  git \
  file \
  imagemagick \
  postgresql-client \
  && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g yarn \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/app

COPY web-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/web-entrypoint.sh

ENTRYPOINT ["web-entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
