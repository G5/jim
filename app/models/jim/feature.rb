class Jim::Feature
  attr_reader :id, :enablements
  attr_accessor :description

  def initialize(id)
    @id = id
    @enablements ||= []
  end

  def add_enablement(enablement_hash)
    @enablements << enablement_class_from_hash(enablement_hash)
  end

  def enabled?
    @enablements.all?(&:enabled?)
  end

protected

  def enablement_class_from_hash(hash)
    case hash["method"]
    when "ruby"
      Jim::Enablements::Ruby.new(hash["class"])
    when "environment"
      Jim::Enablements::Environment.new(
        hash["variable_name"],
        hash["matching"]
      )
    end
  end
end
