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

      if (data.status === 'completed') {
        if (data.image_url) {
          this.imageTarget.src = data.image_url
          this.imageTarget.classList.remove('hidden')
        }
        
        // Update metadata and generation time if the page has these elements
        const metadataContainer = document.querySelector('[data-generation-metadata]')
        if (metadataContainer && data.metadata) {
          let metadataHtml = '<dl class="grid grid-cols-1 gap-2 sm:grid-cols-2">'
          Object.entries(data.metadata).forEach(([key, value]) => {
            metadataHtml += `
              <div>
                <dt class="text-sm font-medium text-gray-500">${key.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}</dt>
                <dd class="mt-1 text-sm text-gray-900">${value}</dd>
              </div>`
          })
          metadataHtml += '</dl>'
          metadataContainer.innerHTML = metadataHtml
        }

        const generationTimeElement = document.querySelector('[data-generation-time]')
        if (generationTimeElement && data.generation_time) {
          generationTimeElement.textContent = `${data.generation_time.toFixed(2)} seconds`
        }

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
