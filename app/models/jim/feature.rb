class Jim::Feature
  attr_reader :id, :enablements, :dependants
  attr_accessor :description

  def initialize(id)
    @id = id
    @enablements = []
    @dependants = []
  end

  def add_enablement(enablement_hash)
    @enablements << enablement_from_hash(enablement_hash)
  end

  def add_dependant(dependant)
    @dependants << dependant
  end

  def enabled?
    @enablements.all?(&:enabled?)
  end

protected

  def enablement_from_hash(hash)
    klass = enablement_class_for_method(hash["method"])
    enablement_arguments = hash.except("method").symbolize_keys

    klass.new(enablement_arguments)
  end

  def enablement_class_for_method(method)
    class_name = method.classify
    "Jim::Enablements::#{class_name}".constantize
  rescue NameError
    raise "I don't know the enablement method '#{method}'"
  end
end
