module GenerationsHelper
  def sample_image_for_style(style)
    # Get the most recent completed generation for this style
    Generation.where(style: style, status: Generation::STATUSES[:completed])
              .where.not(image_url: nil)
              .order(created_at: :desc)
              .first
              &.image_url
  end

  def style_placeholder(style)
    style_name = style.capitalize
    
    content_tag :div, class: "w-full h-full bg-gray-100 relative overflow-hidden flex items-center justify-center" do
      # Center large text
      content_tag(:div, style_name, class: "text-gray-300 font-bold text-6xl opacity-60")
    end
  end
end
