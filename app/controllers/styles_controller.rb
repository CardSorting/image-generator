class StylesController < ApplicationController
  before_action :set_style, except: [:index, :trending]
  before_action :authenticate_user!, only: [:try]

  def index
    styles = Generation::STYLES
    @styles = styles.map { |style| StylePresenter.new(style) }
    @trending_styles = @styles.select(&:is_trending?).first(3)
    
    # Paginate styles for infinite scrolling
    @paginated_styles = Kaminari.paginate_array(@styles)
                               .page(params[:page])
                               .per(12)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def category
    styles = Generation::STYLES
    if params[:category].present?
      styles = styles.select { |style| style[:category].to_s == params[:category] }
    end
    @styles = styles.map { |style| StylePresenter.new(style) }
    render partial: 'styles/category'
  end

  def show
    # Initialize a new generation for the form
    @generation = Generation.new(style: @style)
    
    # Load stats for the style
    @stats = helpers.style_stats(@style)
    @avg_generation_time = Generation.where(style: @style, status: 'completed')
                                   .where('created_at > ?', 7.days.ago)
                                   .average(:generation_time)
    
    # Get featured examples
    @featured_examples = Generation.where(style: @style, status: 'completed')
                                 .where.not(image_url: nil)
                                 .order(created_at: :desc)
                                 .limit(4)

    # Get recent generations for the gallery section
    @recent_generations = Generation.where(style: @style)
                                  .where.not(image_url: nil)
                                  .includes(:user)
                                  .order(created_at: :desc)
                                  .limit(9)

    # Determine which template to render
    if request.path.start_with?('/styles/')
      render @style # This will render app/views/styles/[style].html.erb
    else
      render 'show' # This will render app/views/styles/show.html.erb
    end
  end

  def gallery
    sort = params[:sort] || 'newest'
    @generations = Generation.where(style: @style)
                           .where.not(image_url: nil)
                           .includes(:user)
                           .order(sort_column(sort))
                           .page(params[:page])
                           .per(24)

    @top_tags = Generation.where(style: @style)
                         .where.not(metadata: nil)
                         .where("metadata->>'tags' IS NOT NULL")
                         .group("metadata->>'tags'")
                         .order('count_all DESC')
                         .limit(10)
                         .count
  end

  def analytics
    @weekly_trend = Generation.where(style: @style)
                            .where('created_at > ?', 1.week.ago)
                            .group_by_day(:created_at)
                            .count

    @success_rate = Generation.where(style: @style, status: 'completed')
                            .where('created_at > ?', 30.days.ago)
                            .count * 100.0 / 
                            Generation.where(style: @style)
                                    .where('created_at > ?', 30.days.ago)
                                    .count

    @avg_generation_time = Generation.where(style: @style, status: 'completed')
                                   .where('created_at > ?', 7.days.ago)
                                   .average('EXTRACT(epoch FROM (completed_at - created_at))').to_f
  end

  def try
    redirect_to new_style_generations_path(@style)
  end

  def trending
    @styles = Generation::STYLES
      .map { |style| StylePresenter.new(style) }
      .select(&:is_trending?)
      .sort_by(&:trending_score)
      .reverse
  end

  private

  def set_style
    @style = params[:id] || params[:style]
    @presenter = StylePresenter.new(@style)
    
    unless Generation::STYLES.include?(@style)
      redirect_to styles_path, alert: 'Invalid style selected'
    end
  end

  def sort_column(sort)
    case sort
    when 'popular'
      { likes_count: :desc }
    when 'trending'
      { trending_score: :desc }
    else # 'newest'
      { created_at: :desc }
    end
  end
end
