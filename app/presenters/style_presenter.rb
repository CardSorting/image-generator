class StylePresenter
  include GenerationsHelper
  attr_reader :style_name

  def initialize(style_name)
    @style_name = style_name.to_sym
    @metadata = StyleRegistry.get_style(style_name)
    @stats = nil # Lazy load stats
  end

  def title
    @metadata[:title]
  end

  def description
    @metadata[:description]
  end

  def category
    @metadata[:category]
  end

  def theme_classes
    @metadata[:theme_classes]
  end

  def example_prompt
    @metadata[:example_prompt]
  end

  def category_metadata
    StyleRegistry.categories[category]
  end

  def category_theme
    category_metadata[:theme]
  end

  def category_title
    category_metadata[:title]
  end

  def category_description
    category_metadata[:description]
  end

  def similar_styles
    StyleRegistry.styles_for_category(category).keys - [style_name]
  end

  def stats
    @stats ||= style_stats(style_name)
  end

  def total_generations
    stats[:total_generations]
  end

  def views_count
    stats[:views][:count]
  end

  def likes_count
    stats[:likes][:count]
  end

  def bookmarks_count
    stats[:bookmarks][:count]
  end

  def shares_count
    stats[:shares][:count]
  end

  def engagement_rate
    stats[:engagement_rate]
  end

  def trending_score
    stats[:trending_score]
  end

  def popular_tags
    stats[:popular_tags]
  end

  def popularity_score
    stats[:popularity_score]
  end

  def is_trending?
    trending_score >= 50
  end

  def engagement_color_class
    case engagement_rate
    when 15..100 then "text-emerald-600"
    when 10..14.99 then "text-blue-600"
    when 5..9.99 then "text-yellow-600"
    else "text-gray-600"
    end
  end

  def trending_color_class
    case trending_score
    when 75..100 then "text-red-600"
    when 50..74.99 then "text-orange-600"
    when 25..49.99 then "text-yellow-600"
    else "text-gray-600"
    end
  end

  def card_classes
    [
      "transform transition-all duration-500 ease-in-out",
      "group relative overflow-hidden rounded-lg border",
      theme_classes,
      "shadow-md hover:shadow-xl"
    ].join(" ")
  end

  def image_container_classes
    [
      "aspect-[2/3] w-full overflow-hidden",
      "relative bg-gray-100"
    ].join(" ")
  end

  def image_classes
    [
      "w-full h-full object-cover",
      "transition-opacity duration-300",
      "group-hover:opacity-90"
    ].join(" ")
  end

  def placeholder_classes
    [
      "absolute inset-0 flex items-center justify-center",
      "bg-gradient-to-br #{theme_classes}"
    ].join(" ")
  end

  def metric_badge_classes(type)
    base_classes = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
    
    case type
    when :views
      "#{base_classes} bg-gray-100 text-gray-800"
    when :likes
      "#{base_classes} bg-pink-100 text-pink-800"
    when :bookmarks
      "#{base_classes} bg-purple-100 text-purple-800"
    when :shares
      "#{base_classes} bg-blue-100 text-blue-800"
    when :engagement
      "#{base_classes} #{engagement_color_class} bg-opacity-10"
    when :trending
      "#{base_classes} #{trending_color_class} bg-opacity-10"
    else
      "#{base_classes} text-gray-700 bg-gray-100"
    end
  end

  def format_number(number)
    if number >= 1_000_000
      "#{(number / 1_000_000.0).round(1)}M"
    elsif number >= 1_000
      "#{(number / 1_000.0).round(1)}K"
    else
      number.to_s
    end
  end
end
