require 'spec_helper'

describe Jim::Dependant do
  subject { Jim::Dependant.new("Name", "Description") }

  describe "#name" do
    context "passed a string" do
      its(:name) { should eq("Name") }
    end

    context "passed some other object" do
      subject { Jim::Dependant.new(Jim::Dependant, "Description").name }

      it "makes it a string" do
        should eq("Jim::Dependant")
      end
    end
  end

  describe "#description" do
    its(:description) { should include("Description") }
    its(:description) { should be_html_safe }
  end
end
