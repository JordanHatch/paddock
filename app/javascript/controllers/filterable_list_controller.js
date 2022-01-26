import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['button']

  connect () {
    this.buttonTarget.style.display = 'none'
  }

  update () {
    this.buttonTarget.click()
  }
}
