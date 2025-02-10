class GenerationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_generation, only: [:show]

  def index
    @generations = current_user.generations.order(created_at: :desc)
  end

  def show
    respond_to do |format|
      format.html
      format.json { 
        render json: {
          status: @generation.status,
          image_url: @generation.image_url,
          error_message: @generation.error_message,
          metadata: @generation.metadata,
          generation_time: @generation.generation_time
        }
      }
    end
  end

  def new
    @generation = Generation.new
  end

  def create
    @generation = current_user.generations.build(generation_params)

    if @generation.save
      # Enqueue the background job for image generation
      GenerateImageJob.perform_later(@generation.id)
      
      redirect_to @generation, notice: 'Image generation has been initiated. Please wait while we process your request.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_generation
    @generation = current_user.generations.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to generations_path, alert: 'Image generation not found.'
  end

  def generation_params
    params.require(:generation).permit(:prompt, :style, :size)
  end
end
