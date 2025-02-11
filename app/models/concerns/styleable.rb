module Styleable
  extend ActiveSupport::Concern
  
  included do
    # Define abstract methods that must be implemented by including classes
    def sample_images
      raise NotImplementedError, "#{self.class} must implement #sample_images"
    end
    
    def style_metadata
      raise NotImplementedError, "#{self.class} must implement #style_metadata"
    end

    def style_category
      raise NotImplementedError, "#{self.class} must implement #style_category"
    end

    def style_theme_classes
      raise NotImplementedError, "#{self.class} must implement #style_theme_classes"
    end
  end
end
