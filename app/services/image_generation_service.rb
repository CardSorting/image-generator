require 'uri'
require 'json'
require 'net/http'

class ImageGenerationService
  def initialize(generation)
    @generation = generation
    credentials = Rails.application.credentials
    @api_key = credentials.modelslab&.api_key || ENV['MODELSLAB_API_KEY']
    @model_id = credentials.modelslab&.model_id || ENV['MODELSLAB_MODEL_ID']
    
    unless @api_key && @model_id
      raise "Missing ModelsLab API credentials. Please set modelslab.api_key and modelslab.model_id in credentials.yml.enc or environment variables"
    end
  end

  def generate
    url = URI("https://modelslab.com/api/v6/images/text2img")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
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
    
    # Map style to enhance_style parameter
    style_mapping = {
      "natural" => "photograph",
      "artistic" => "digital-art",
      "cartoon" => "anime",
      "realistic" => "hyperrealism"
    }

    # Default negative prompt for better quality results
    negative_prompt = "painting, extra fingers, mutated hands, poorly drawn hands, poorly drawn face, deformed, ugly, blurry, bad anatomy, bad proportions, extra limbs, cloned face, skinny, glitchy, double torso, extra arms, extra hands, mangled fingers, missing lips, ugly face, distorted face, extra legs, anime"
    
    JSON.dump({
      key: @api_key,
      model_id: @model_id,
      prompt: @generation.prompt,
      negative_prompt: negative_prompt,
      width: width.to_s,
      height: height.to_s,
      samples: "1",
      num_inference_steps: "20", # Capped at 20 per API docs
      safety_checker: "yes",
      safety_checker_type: "blur",
      enhance_prompt: "yes",
      enhance_style: style_mapping[@generation.style] || "photograph",
      seed: nil,
      guidance_scale: 7.5,
      panorama: "no",
      self_attention: "yes", # Set to yes for higher quality
      upscale: "2", # 2x upscaling for better resolution
      clip_skip: 2,
      base64: "no",
      tomesd: "yes",
      use_karras_sigmas: "yes",
      highres_fix: "yes",
      scheduler: "UniPCMultistepScheduler"
    })
  end

  def handle_response(response)
    if response.code.to_i == 200
      result = JSON.parse(response.body)
      
      if result["status"] == "success" && result["output"].is_a?(Array) && !result["output"].empty?
        image_url = result["output"].first
        generation_time = result["generationTime"]
        
        metadata = result["meta"]&.slice(
          "prompt", "model_id", "scheduler", "guidance_scale", 
          "seed", "steps", "W", "H"
        )

        @generation.update(
          status: Generation::STATUSES[:completed],
          image_url: image_url,
          metadata: metadata,
          generation_time: generation_time
        )
        true
      else
        @generation.update(
          status: Generation::STATUSES[:failed],
          error_message: "API request failed: Invalid response format"
        )
        false
      end
    else
      @generation.update(
        status: Generation::STATUSES[:failed],
        error_message: "API request failed with status #{response.code}: #{response.body}"
      )
      false
    end
  end
end
