import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['closeLink']

  close () {
    this.closeLinkTarget.click()
  }
}
