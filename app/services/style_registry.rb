class StyleRegistry
  class << self
    def register_style(name, metadata)
      @styles ||= {}
      @styles[name.to_sym] = metadata
    end

    def get_style(name)
      @styles ||= {}
      @styles[name.to_sym]
    end

    def styles_for_category(category)
      @styles ||= {}
      @styles.select { |_, metadata| metadata[:category] == category }
    end

    def all_styles
      @styles ||= {}
      @styles
    end

    def categories
      {
        realistic: {
          title: "Realistic Styles",
          description: "Photo-realistic outputs with natural lighting and textures",
          theme: "bg-stone-50 border-stone-200",
          styles: [:natural, :realistic]
        },
        creative: {
          title: "Creative Styles",
          description: "Artistic interpretations with unique visual elements",
          theme: "bg-blue-50 border-blue-200",
          styles: [:artistic, :cartoon]
        }
      }
    end

    def reset
      @styles = {}
    end
  end

  # Default style registrations
  register_style :natural,
    category: :realistic,
    title: "Natural",
    description: "Photo-realistic images with natural lighting and textures",
    theme_classes: "bg-emerald-50 hover:bg-emerald-100 border-emerald-200",
    example_prompt: "A serene mountain landscape at sunrise"

  register_style :realistic,
    category: :realistic,
    title: "Realistic",
    description: "Highly detailed images with precise lighting and shadows",
    theme_classes: "bg-amber-50 hover:bg-amber-100 border-amber-200",
    example_prompt: "A detailed portrait in natural lighting"

  register_style :artistic,
    category: :creative,
    title: "Artistic",
    description: "Creative interpretations with artistic flair",
    theme_classes: "bg-violet-50 hover:bg-violet-100 border-violet-200",
    example_prompt: "An impressionist painting of a garden"

  register_style :cartoon,
    category: :creative,
    title: "Cartoon",
    description: "Fun, animated style with bold colors",
    theme_classes: "bg-pink-50 hover:bg-pink-100 border-pink-200",
    example_prompt: "A cute cartoon character"
end
