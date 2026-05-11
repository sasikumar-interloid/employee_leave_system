import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
static targets = ["sidebar", "label"]

  connect() {
    this.collapsed = false
  }

  toggle() {
    this.collapsed = !this.collapsed

    if (this.collapsed) {
      this.sidebarTarget.classList.remove("w-[264px]")
      this.sidebarTarget.classList.add("w-[80px]")

      this.labelTargets.forEach((label) => {
        label.classList.add("hidden")
      })
    } else {
      this.sidebarTarget.classList.remove("w-[80px]")
      this.sidebarTarget.classList.add("w-[264px]")

      this.labelTargets.forEach((label) => {
        label.classList.remove("hidden")
      })   
    }
  }
}