class GenerationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_generation, only: [:show]

  def index
    @generations = current_user.generations.order(created_at: :desc)
  end

  def show
  end

  def new
    @generation = Generation.new
  end

  def create
    @generation = current_user.generations.build(generation_params)

    if @generation.save
      # TODO: In a real implementation, we would:
      # 1. Trigger a background job to handle the AI generation
      # 2. Update the status via webhooks or polling
      # For now, we'll just simulate success
      @generation.update(
        status: Generation::STATUSES[:completed],
        image_url: "https://placekitten.com/512/512" # Placeholder image
      )
      
      redirect_to @generation, notice: 'Image generation was successfully initiated.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_generation
    @generation = current_user.generations.find(params[:id])
  end

  def generation_params
    params.require(:generation).permit(:prompt, :style, :size)
  end
end
