module Jim::Enablements
  class Environment
    attr_accessor :variable_name, :regex, :redact_value

    def initialize(variable_name, regex, redact_value = false)
      @variable_name, @regex, @redact_value = variable_name, regex, redact_value
      @value = ENV[@variable_name]
    end

    def enabled?
      @value.present? && @value.match(@regex)
    end

    def value
      @redact_value ? nil : @value
    end

    def to_partial_path
      "enablements/environment"
    end
  end
end
