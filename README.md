# AI Image Generator

A Ruby on Rails application that generates AI images using a third-party API. Features include:
- User authentication
- Real-time generation status updates
- Multiple image styles and sizes
- Background job processing
- Responsive design with Tailwind CSS

## Prerequisites

- Ruby 3.4.1
- PostgreSQL
- Redis (for Sidekiq)
- Node.js and npm

## Setup

1. Clone the repository and install dependencies:
```bash
bundle install
npm install
```

2. Set up the database:
```bash
bin/rails db:create db:migrate
```

3. Configure the ModelsLab API credentials:

Option 1 - Using credentials.yml.enc:
```bash
EDITOR="code --wait" bin/rails credentials:edit
```

Add the following structure:
```yaml
modelslab:
  api_key: "YOUR_API_KEY"
  model_id: "flux"  # Options: flux, fluxschnell, fluxdev
```

Option 2 - Using environment variables:
Create or update your `.env` file:
```bash
MODELSLAB_API_KEY=your_api_key_here
MODELSLAB_MODEL_ID=flux
```

Model ID Options:
- `flux`: Basic text to image
- `fluxschnell`: Text to image + Image to image
- `fluxdev`: All features (Text to image, Image to image, Inpaint, ControlNet, Lora)

4. Start Redis for background job processing:
```bash
redis-server
```

5. Start the development server:
```bash
bin/dev
```

The application will be available at http://localhost:3000

## Running Background Jobs

This application uses Sidekiq for processing image generation jobs. To start Sidekiq:

```bash
bundle exec sidekiq
```

## Development

- The main image generation logic is in `app/services/image_generation_service.rb`
- Background jobs are in `app/jobs/`
- Frontend uses Stimulus.js for real-time updates
- Styling is done with Tailwind CSS

## Testing

Run the test suite:

```bash
bin/rails test
```

## Production Deployment

1. Set up required environment variables:
   - `REDIS_URL`
   - Database credentials
   - API credentials

2. Ensure Sidekiq is configured to run as a background process

3. Configure your web server (e.g., Nginx) to serve the application

## Contributing

1. Fork the repository
2. Create your feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.
