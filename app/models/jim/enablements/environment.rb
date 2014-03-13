module Jim::Enablements
  class Environment
    def initialize(variable_name, regex)
      @variable_name, @regex = variable_name, regex
    end

    def enabled?
      value = ENV[@variable_name]
      value.present? && value.match(@regex)
    end
  end
end
