import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['closeLink']

  close () {
    this.element.innerHTML = ''
    this.element.attributes.src = ''
  }

  keyup (event) {
    if (event.code === 'Escape') {
      this.close()
    }
  }
}
