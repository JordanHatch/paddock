import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    this.element.style.display = 'none'

    setTimeout(() => {
      console.dir(this.element)
      this.element.click()
    }, 3000)
  }
}
