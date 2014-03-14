module Jim::Enablements
  class Environment
    attr_accessor :variable_name, :regex, :redact_value, :example

    def initialize(variable_name:, matching:, redact_value: false, example: nil)
      @variable_name, @regex, @redact_value, @example =
        variable_name, matching, redact_value, example
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