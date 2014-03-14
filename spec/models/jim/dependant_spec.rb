require 'spec_helper'

describe Jim::Dependant do
  subject { Jim::Dependant.new("Name", "Description") }

  its(:name) { should eq("Name") }

  describe "#description" do
    its(:description) { should include("Description") }
    its(:description) { should be_html_safe }
  end
end
