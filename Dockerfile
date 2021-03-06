FROM ruby:3.0.3

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
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
    bundle install

ADD . $APP_HOME

RUN RAILS_ENV=production SECRET_KEY_BASE=example_secret_key_for_assets bundle exec rails assets:precompile

HEALTHCHECK CMD curl --silent --fail localhost:$PORT || exit 1

RUN wget -q -O entrypoint.zip \
    https://releases.hashicorp.com/waypoint-entrypoint/0.9.0/waypoint-entrypoint_0.9.0_linux_386.zip && \
    unzip entrypoint.zip && \
    mv waypoint-entrypoint /

CMD foreman run web
