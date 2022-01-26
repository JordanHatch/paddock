import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['form', 'loading', 'loadingMessage']

  showLoadingMessage () {
    this.formTarget.style.display = 'none'
    this.loadingTarget.style.display = 'block'
    this.loadingMessageTarget.innerText = 'Signing you in...'
  }
}
