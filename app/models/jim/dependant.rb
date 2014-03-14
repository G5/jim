class Jim::Dependant
  attr_reader :name

  def initialize(name, description)
    @name, @description = name, description
  end

  def description
    Jim.markdown_render(@description)
  end
end
