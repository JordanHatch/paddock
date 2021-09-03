// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from '@rails/ujs'
import * as ActiveStorage from '@rails/activestorage'
import '@hotwired/turbo-rails'

import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

import NestedForm from 'stimulus-rails-nested-form'
import TomSelect from 'tom-select'

import 'stylesheets/application.scss'

Rails.start()
ActiveStorage.start()

const application = Application.start()
application.register('nested-form', NestedForm)

const context = require.context('../controllers', true, /\.js$/)
application.load(definitionsFromContext(context))

document.addEventListener('turbo:render', function () {
  document.querySelectorAll('select').forEach((el) => {
    // eslint-disable-next-line no-new
    new TomSelect(el, {
      selectOnTab: true,
      closeAfterSelect: true
    })
  })
})
