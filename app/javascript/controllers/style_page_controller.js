import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "gallery", "galleryFilter"]

  connect() {
    // Initialize any necessary state
  }

  scrollToForm(event) {
    event.preventDefault()
    this.formTarget.scrollIntoView({ behavior: "smooth" })
  }

  filterGallery(event) {
    const filter = event.currentTarget.dataset.filter
    
    // Remove active state from all filters
    this.galleryFilterTargets.forEach(btn => {
      btn.classList.remove("bg-gray-100")
    })
    
    // Add active state to clicked filter
    event.currentTarget.classList.add("bg-gray-100")
    
    // TODO: Add actual filtering logic once backend endpoints are set up
    console.log(`Filtering gallery by: ${filter}`)
  }

  shareStyle(event) {
    event.preventDefault()
    
    // Get the current URL
    const url = window.location.href
    
    // Use Web Share API if available
    if (navigator.share) {
      navigator.share({
        title: 'Natural Style Generation',
        text: 'Check out this amazing AI image generation style!',
        url: url
      })
    } else {
      // Fallback to copying to clipboard
      navigator.clipboard.writeText(url).then(() => {
        // TODO: Show a toast notification
        console.log('URL copied to clipboard')
      })
    }
  }
}
