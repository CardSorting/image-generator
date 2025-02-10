class GenerateImageJob < ApplicationJob
  queue_as :default

  def perform(generation_id)
    generation = Generation.find(generation_id)
    ImageGenerationService.new(generation).generate
  end
end
