require 'spec_helper'

describe Jim::Feature do
  let(:feature) { Jim::Feature.new(:time_travel) }

  describe "#dependants" do
    subject { feature.dependants }

    context "by default" do
      it { should be_empty }
    end

    context "after adding a Dependant" do
      let(:dependant) { Jim::Dependant.new("Test", "Test") }
      before { feature.add_dependant(dependant) }

      it { should eq([ dependant ]) }
    end
  end
end
