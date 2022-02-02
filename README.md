# Paddock

A prototype app for sprint reporting.

## Quick start

### Setting up the development environment

If you use [asdf](https://asdf-vm.com/) to manage your NodeJS and Ruby versions:

```
asdf plugin add nodejs
asdf plugin add ruby
asdf install
```

Then install Bundler and Yarn:

```
gem install bundler
npm install --global yarn
```

You may need to configure your PostgreSQL bindings to install the `pg` gem:

```
# Mac
brew install libpq
bundle config build.pg --with-pg-config=/usr/local/opt/libpq/bin/pg_config
```

Then run Bundler and Yarn to install the application dependencies:

```
bundle install
yarn install
```

Set up the empty database:

```
bin/rake db:setup
```

To collect email locally, install and run [Mailcatcher](https://github.com/sj26/mailcatcher):

```
gem install mailcatcher
mailcatcher
```

If you encounter issues installing `thin`, there's a workaround in [the Mailcatcher README](https://github.com/sj26/mailcatcher/blob/main/README.md).

Once complete, start the app in development:

```
bin/dev
```

## Running the tests

```
bin/rake
```
