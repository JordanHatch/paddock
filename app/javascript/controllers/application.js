import { Application } from '@hotwired/stimulus'
import NestedForm from 'stimulus-rails-nested-form'

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

application.register('nested-form', NestedForm)

export { application }
