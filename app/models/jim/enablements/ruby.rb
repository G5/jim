module Jim::Enablements
  class Ruby
    def initialize(class_name)
      @klass = class_name.constantize
    end

    def enabled?
      @klass.enable?
    end

    def description
      @klass.try(:description)
    end

    def to_partial_path
      "enablements/ruby"
    end
  end
end
