import { Controller } from 'stimulus'
import Sortable from 'sortablejs'

export default class extends Controller {
  static targets = ['list', 'submit']

  connect () {
    this.hideInputFields()

    const options = {
      animation: 150,
      onEnd: this.onEnd.bind(this)
    }

    return new Sortable(this.listTarget, options)
  }

  hideInputFields () {
    this.listTarget
      .querySelectorAll('[data-sortable-commitments-list-target=input]')
      .forEach((item) => {
        item.style.display = 'none'
      })
  }

  onEnd (event) {
    const newList = event.to
    const listItems = newList.querySelectorAll('li')

    listItems.forEach(this.updateNumber.bind(this))
  }

  updateNumber (item, index) {
    const newNumber = index + 1

    this.updateCommitmentNumber(item, newNumber)
    this.updateInputField(item, newNumber)
  }

  updateCommitmentNumber (item, number) {
    const selector = '[data-sortable-commitments-list-target=number]'
    const el = item.querySelector(selector)

    el.innerHTML = number
  }

  updateInputField (item, number) {
    const selector = '[data-sortable-commitments-list-target=input]'
    const el = item.querySelector(selector)

    el.value = number
  }
}
