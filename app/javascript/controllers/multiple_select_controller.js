import { Controller } from 'stimulus'
import Choices from 'choices.js'

export default class extends Controller {
  static targets = ['input']
  static values = {
    placeholder: String
  }

  connect () {
    const options = {
      placeholderValue: this.placeholderValue,
      removeItemButton: true
    }

    return new Choices(this.inputTarget, options)
  }
}
