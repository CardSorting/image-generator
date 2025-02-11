import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.setupTooltips()
    this.setupHoverEffects()
  }

  setupTooltips() {
    // Add any tooltip initialization if needed
    // Currently using CSS-only tooltips with group-hover
  }

  setupHoverEffects() {
    const card = this.element
    
    // Subtle tilt effect on hover
    card.addEventListener('mousemove', (e) => {
      const rect = card.getBoundingClientRect()
      const x = e.clientX - rect.left
      const y = e.clientY - rect.top
      
      const xPercent = (x / rect.width - 0.5) * 4
      const yPercent = (y / rect.height - 0.5) * 4
      
      card.style.transform = `
        perspective(1000px)
        rotateX(${-yPercent}deg)
        rotateY(${xPercent}deg)
        scale3d(1.02, 1.02, 1.02)
      `
    })
    
    // Reset transform on mouse leave
    card.addEventListener('mouseleave', () => {
      card.style.transform = ''
    })
  }
}
