module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        polaroid: {
          frame: '#FAF9F6', // Warm off-white
          border: '#E8E6E1', // Subtle border color
        }
      },
      boxShadow: {
        'polaroid': '0 6px 12px rgba(0, 0, 0, 0.12), 0 0 0 5px #FAF9F6, 0 0 0 6px rgba(0, 0, 0, 0.03), inset 0 2px 4px rgba(0, 0, 0, 0.04)',
        'polaroid-hover': '0 12px 24px rgba(0, 0, 0, 0.15), 0 0 0 5px #FAF9F6, 0 0 0 6px rgba(0, 0, 0, 0.05), inset 0 2px 4px rgba(0, 0, 0, 0.06)',
      },
      keyframes: {
        wiggle: {
          '0%, 100%': { transform: 'rotate(-1deg)' },
          '50%': { transform: 'rotate(1.5deg)' },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-10px)' },
        }
      },
      animation: {
        wiggle: 'wiggle 4s ease-in-out infinite',
        float: 'float 6s ease-in-out infinite',
      },
      fontFamily: {
        handwriting: ['Pangolin', 'cursive'],
      },
    },
  },
  plugins: [],
}
