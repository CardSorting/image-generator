// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

document.addEventListener('DOMContentLoaded', () => {
  const sidebarLinks = document.querySelectorAll('.w-64 nav a'); // Assuming the sidebar links are inside a nav element

  sidebarLinks.forEach(link => {
    link.addEventListener('click', (event) => {
      event.preventDefault();
      const category = link.href.split('category=')[1]; // Extract category from the URL
      
      fetch(`/styles/category/${category}`)
        .then(response => response.text())
        .then(html => {
          const contentArea = document.querySelector('.flex-1.ml-64 .py-8.px-6'); // Target the main content area
          if (contentArea) {
            contentArea.innerHTML = html;
          }
        })
        .catch(error => console.error('Error fetching styles:', error));
    });
  });
});
