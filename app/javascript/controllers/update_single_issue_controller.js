import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['title', 'toggle', 'content', 'description']
  static classes = ['closed']

  connect () {
    // New records get a non-null value for the 'data-new-record'
    // attribute as part of the stimulus-nested-form plugin.
    const isNewRecord = (this.element.getAttribute('data-new-record') === '')

    if (isNewRecord) {
      this.descriptionTarget.focus()
    } else {
      this.element.classList.add(this.closedClass)
    }
  }

  toggle () {
    this.element.classList.toggle(this.closedClass)
  }

  updateHeader () {
    const newDescription = this.descriptionTarget.value
    this.titleTarget.innerHTML = newDescription
  }
}
