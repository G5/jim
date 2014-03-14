module Jim::Feature::Dependant
  extend ActiveSupport::Concern

  included do
    attr_reader :dependants
  end

  def initialize_dependant
    @dependants = []
  end

  def add_dependant(dependant)
    @dependants << dependant
  end
end
