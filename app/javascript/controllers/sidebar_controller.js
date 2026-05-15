import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
static targets = ["sidebar", "label"]

  connect() {
    this.collapsed = false
  }

  toggle(event) {
    this.collapsed = !this.collapsed

    if (this.collapsed) {
      this.sidebarTarget.classList.remove("w-64")
      this.sidebarTarget.classList.add("w-20")

      this.labelTargets.forEach((label) => {
        label.classList.add("hidden")
      })
    } else {
      this.sidebarTarget.classList.remove("w-20")
      this.sidebarTarget.classList.add("w-64")

      this.labelTargets.forEach((label) => {
        label.classList.remove("hidden")
      })   
    }
  }
}