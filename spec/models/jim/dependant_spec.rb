require 'spec_helper'

describe Jim::Dependant do
  subject { Jim::Dependant.new("Name", "Description") }

  its(:name) { should eq("Name") }
  its(:description) { should eq("Description") }
end
