Rails.application.configure do
  config.assets.paths << 'node_modules/@fontsource/public-sans/files'
  config.assets.paths << 'node_modules/@fontsource/fira-code/files'

  config.assets.paths << 'node_modules/@fortawesome/fontawesome-free/webfonts'
end
