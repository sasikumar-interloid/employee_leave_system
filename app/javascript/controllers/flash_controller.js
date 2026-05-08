import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
 connect() {
    this.timeout = setTimeout(() => {
      this.remove()
    }, 4000)
  }

  remove() {
    this.element.classList.add(
      "opacity-0",
      "translate-x-4",
      "transition-all",
      "duration-300"
    )

    setTimeout(() => {
      this.element.remove()
    }, 300)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
