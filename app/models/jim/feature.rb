class Jim::Feature
  include Enablement
  include Dependant

  attr_reader :id
  attr_accessor :description

  def initialize(id)
    @id = id
    initialize_enablement
    initialize_dependant
  end
end
