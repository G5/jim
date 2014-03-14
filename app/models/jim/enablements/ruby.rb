module Jim::Enablements
  class Ruby
    def initialize(class_name:)
      @klass = class_name.constantize
    end

    def enabled?
      @klass.enable?
    end

    def description
      Jim.markdown_render(description_from_klass)
    end

    def to_partial_path
      "enablements/ruby"
    end

  protected

    def description_from_klass
      @klass.try(:description) || ""
    end
  end
end
