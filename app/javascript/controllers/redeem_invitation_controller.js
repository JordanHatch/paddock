import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'button', 'form', 'loading', 'loadingMessage' ]

  connect() {
    this.buttonTarget.click()
  }

  showLoadingMessage() {
    this.formTarget.style.display = 'none'
    this.loadingTarget.style.display = 'block'
    this.loadingMessageTarget.innerText = 'Signing you in...'
  }

}
