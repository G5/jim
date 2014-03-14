require 'spec_helper'

describe Jim::Feature do
  let(:feature) { Jim::Feature.new(:time_travel) }

  describe "#id" do
    subject { feature.id }
    it { should eq(:time_travel) }
  end

  describe "#description" do
    subject { feature.description }

    context "when none has been set" do
      it { should be_nil }
    end

    context "when one has been set" do
      before { feature.description = "test" }
      it { should eq("test") }
    end
  end
end
