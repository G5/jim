class Jim::Feature
  include Enablement
  include Dependant

  attr_reader :id
  attr_writer :description

  def initialize(id)
    @id = id
    initialize_enablement
    initialize_dependant
  end

  def description
    Jim.markdown_render(@description)
  end
end
