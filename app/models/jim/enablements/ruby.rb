module Jim::Enablements
  class Ruby
    def initialize(class_name)
      @klass = class_name.constantize
    end

    def enabled?
      @klass.enable?
    end
  end
end
