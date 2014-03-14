module Jim::Feature::Enablement
  extend ActiveSupport::Concern

  included do
    attr_reader :enablements
  end

  def initialize_enablement
    @enablements = []
  end

  def add_enablement(enablement_hash)
    @enablements << enablement_from_hash(enablement_hash)
  end

  def enabled?
    enablements.all?(&:enabled?)
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
