import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["entries", "pagination"]
  static values = {
    url: String,
    page: Number,
    loading: Boolean
  }

  initialize() {
    this.intersectionObserver = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.loadMore()
        }
      })
    }, { rootMargin: "100px" })
  }

  connect() {
    if (this.hasPaginationTarget) {
      this.intersectionObserver.observe(this.paginationTarget)
    }
  }

  disconnect() {
    this.intersectionObserver.disconnect()
  }

  async loadMore() {
    if (this.loadingValue) return
    
    this.loadingValue = true
    const nextPage = this.pageValue + 1
    
    try {
      const url = new URL(this.urlValue)
      url.searchParams.set('page', nextPage)
      
      const response = await fetch(url, {
        headers: {
          'Accept': 'text/vnd.turbo-stream.html'
        }
      })
      
      if (!response.ok) throw new Error('Network response was not ok')
      
      const html = await response.text()
      if (html.trim().length > 0) {
        Turbo.renderStreamMessage(html)
        this.pageValue = nextPage
      } else {
        // No more content, remove the observer
        if (this.hasPaginationTarget) {
          this.intersectionObserver.unobserve(this.paginationTarget)
        }
      }
    } catch (error) {
      console.error('Error loading more content:', error)
    } finally {
      this.loadingValue = false
    }
  }
}
