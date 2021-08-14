// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

import NestedForm from "stimulus-rails-nested-form"

import 'stylesheets/application.scss'

Rails.start()
ActiveStorage.start()

const application = Application.start()
application.register('nested-form', NestedForm)

const context = require.context("../controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

import TomSelect from "tom-select"

document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('select').forEach((el) => {
    new TomSelect(el, {
      selectOnTab: true,
      closeAfterSelect: true
    })
  })
})
