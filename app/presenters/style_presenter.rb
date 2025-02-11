class StylePresenter
  attr_reader :style_name

  def initialize(style_name)
    @style_name = style_name.to_sym
    @metadata = StyleRegistry.get_style(style_name)
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
end
