module Jim::Enablements
  class Environment
    attr_accessor :variable_name, :regex, :value

    def initialize(variable_name, regex)
      @variable_name, @regex = variable_name, regex
      @value = ENV[@variable_name]
    end

    def enabled?
      value.present? && value.match(@regex)
    end

    def to_partial_path
      "enablements/environment"
    end
  end
end
