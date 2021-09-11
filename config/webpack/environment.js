const { environment } = require('@rails/webpacker')
const globImporter = require('node-sass-glob-importer')

environment.loaders.get('sass')
  .use
  .find(item => item.loader === 'sass-loader')
  .options
  .sassOptions = {
    importer: globImporter(),
    includePaths: [
      'app/assets/stylesheets'
    ]
  }

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader'
})

module.exports = environment
