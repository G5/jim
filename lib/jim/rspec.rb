module Jim::Rspec
  def self.permanently_disabled(feature_ids = nil)
    @permanently_disabled ||= []

    if feature_ids.nil?
      @permanently_disabled
    else
      @permanently_disabled += feature_ids
    end
  end
end

require 'jim/rspec/enabler'
