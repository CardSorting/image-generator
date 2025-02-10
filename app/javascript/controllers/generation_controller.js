import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status", "image", "error"]
  static values = {
    id: Number,
    refreshInterval: { type: Number, default: 2000 }
  }

  connect() {
    if (this.hasIdValue && ["pending", "processing"].includes(this.statusTarget.dataset.status)) {
      this.startPolling()
    }
  }

  disconnect() {
    if (this.pollingTimeout) {
      clearTimeout(this.pollingTimeout)
    }
  }

  startPolling() {
    this.pollStatus()
  }

  async pollStatus() {
    try {
      const response = await fetch(`/generations/${this.idValue}.json`)
      const data = await response.json()
      
      this.statusTarget.textContent = data.status.toUpperCase()
      this.statusTarget.dataset.status = data.status

      if (data.error_message) {
        this.errorTarget.textContent = data.error_message
        this.errorTarget.classList.remove('hidden')
      }

      if (data.image_url && data.status === 'completed') {
        this.imageTarget.src = data.image_url
        this.imageTarget.classList.remove('hidden')
        return // Stop polling once completed
      }

      if (["pending", "processing"].includes(data.status)) {
        this.pollingTimeout = setTimeout(() => this.pollStatus(), this.refreshIntervalValue)
      }
    } catch (error) {
      console.error("Error polling generation status:", error)
      this.errorTarget.textContent = "Error checking generation status. Please refresh the page."
      this.errorTarget.classList.remove('hidden')
    }
  }
}
