class GenerationsController < ApplicationController
  before_action :authenticate_user!, except: [:style_page]
  before_action :set_generation, only: [:show]
  before_action :set_style, only: [:new_style]

  def index
    @generations = current_user.generations.order(created_at: :desc)
  end

  def show
    @generation.increment(:view_count)
    @generation.save

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

  def like
    @generation = current_user.generations.find(params[:id])
    @generation.increment(:like_count)
    @generation.save
    redirect_to @generation, notice: 'Liked!'
  rescue ActiveRecord::RecordNotFound
    redirect_to generations_path, alert: 'Image generation not found.'
  end

  def unlike
    @generation = current_user.generations.find(params[:id])
    if @generation.like_count > 0
      @generation.decrement(:like_count)
      @generation.save
    end
    redirect_to @generation, notice: 'Unliked!'
  rescue ActiveRecord::RecordNotFound
    redirect_to generations_path, alert: 'Image generation not found.'
  end

  def new
    @generation = Generation.new
  end

  def new_style
    @style = params[:style]
    render :new
  end

  def create
    @generation = current_user.generations.build(generation_params)

    if @generation.save
      # Enqueue the background job for image generation
      GenerateImageJob.perform_later(@generation.id)
      
      redirect_to @generation, notice: 'Image generation has been initiated. Please wait while we process your request.'
    else
      if @generation.style.present? && Generation::STYLES.include?(@generation.style)
        redirect_to style_page_styles_path(@generation.style), status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
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

  def set_style
    unless Generation::STYLES.include?(params[:style].to_s)
      redirect_to new_generation_path, alert: 'Invalid generation style selected.'
    end
  end
end
