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
      it { should be_blank }
    end

    context "when one has been set" do
      before { feature.description = "test" }

      it { should include("test") }
      it { should be_html_safe }
    end
  end
end
