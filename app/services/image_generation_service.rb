require 'uri'
require 'json'
require 'net/http'

class ImageGenerationService
  TENSOR_API_ENDPOINT = 'https://ap-east-1.tensorart.cloud'
  TOKEN = '92cad8c1-0b2c-4559-b8bc-a2d100f48190'

  def initialize(generation)
    @generation = generation
  end

  def generate
    url = URI("#{TENSOR_API_ENDPOINT}/v1/jobs")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json; charset=UTF-8"
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer #{TOKEN}"
    request.body = build_request_body

    @generation.update(status: Generation::STATUSES[:processing])
    
    begin
      response = https.request(request)
      handle_response(response)
    rescue StandardError => e
      @generation.update(
        status: Generation::STATUSES[:failed],
        error_message: "API request failed: #{e.message}"
      )
      Rails.logger.error("Image generation failed: #{e.message}")
      false
    end
  end

  private

  def build_request_body
    width, height = @generation.size.split('x').map(&:to_i)
    JSON.dump({
      request_id: @generation.id.to_s,
      stages: [
        {
          type: "INPUT_INITIALIZE",
          inputInitialize: {
            seed: -1,
            count: 1
          }
        },
        {
          type: "DIFFUSION",
          diffusion: {
            width: width,
            height: height,
            prompts: [{ text: @generation.prompt }],
            steps: 20,
            sd_model: model_for_style,
            clip_skip: 2,
            cfg_scale: 7
          }
        }
      ]
    })
  end

  def model_for_style
    # Using a default model ID from Tensor API
    # This should be updated with actual model IDs from Tensor Art
    "600423083519508503"
  end

  def handle_response(response)
    if response.code.to_i == 200
      result = JSON.parse(response.body)
      job_id = result["job_id"]
      @generation.update(
        status: Generation::STATUSES[:completed],
        image_url: "#{TENSOR_API_ENDPOINT}/v1/jobs/#{job_id}/result"
      )
      true
    else
      @generation.update(
        status: Generation::STATUSES[:failed],
        error_message: "API request failed with status #{response.code}: #{response.body}"
      )
      false
    end
  end
end
