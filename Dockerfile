FROM ruby:3.0.1-alpine

RUN apk add --no-cache --update build-base \
    linux-headers \
    git \
    postgresql-dev \
    nodejs \
    yarn \
    tzdata

EXPOSE 3000

ENV PORT 3000
ENV RAILS_ENV production
ENV APP_HOME /app

RUN mkdir $APP_HOME

WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
ADD .ruby-version $APP_HOME/
ADD yarn.lock $APP_HOME/

RUN gem install foreman && \
    bundle config set without development test && \
    bundle install && \
    bundle clean --force

RUN yarn install

ADD . $APP_HOME

RUN RAILS_ENV=production SECRET_KEY_BASE=example_secret_key_for_assets bundle exec rails assets:clean assets:precompile

HEALTHCHECK CMD curl --silent --fail localhost:$PORT || exit 1

RUN wget -q -O entrypoint.zip \
    https://releases.hashicorp.com/waypoint-entrypoint/0.4.2/waypoint-entrypoint_0.4.2_linux_386.zip && \
    unzip entrypoint.zip && \
    mv waypoint-entrypoint /

CMD foreman run web
