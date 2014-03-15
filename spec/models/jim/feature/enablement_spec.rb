class FeatureSpecEnablement
  def self.enable?
    true
  end

  def self.description
    "Test from Feature spec"
  end
end

require 'spec_helper'

describe Jim::Feature do
  let(:feature) { Jim::Feature.new(:time_travel) }

  describe "#add_enablement" do
    context "with an unknown method value" do
      it "raises a helpful exception" do
        expect {
          feature.add_enablement("method" => "Bad")
        }.to raise_error(/enablement method 'Bad'/)
      end
    end
  end

  describe "#enabled?" do
    before do
      feature.add_enablement(
        "method" => "environment",
        "variable_name" => "SHELL",
        "matching" => /.+/
      )
    end
    subject { feature.enabled? }

    context "with all enabled enablements" do
      it { should be_true }
    end

    context "with one disabled enablement" do
      before do
        feature.add_enablement(
          "method" => "environment",
          "variable_name" => "BAD",
          "matching" => /.+/
        )
      end

      it { should be_false }
    end

    context "with depended features" do
      let(:other) { Jim::Feature.new(:test) }
      before { feature.depends_on(other) }

      context "when the depended feature is enabled" do
        before { other.stub(enabled?: true) }
        it { should be_true }
      end

      context "when the depended feature is disabled" do
        before { other.stub(enabled?: false) }
        it { should be_false }
      end
    end
  end

  describe "#enablements" do
    before do
      feature.add_enablement(
        "method" => "environment",
        "variable_name" => "SHELL",
        "matching" => /.+/
      )
      feature.add_enablement(
        "method" => "ruby",
        "class_name" => "FeatureSpecEnablement"
      )
    end
    subject(:enablements) { feature.enablements }

    its(:length) { should eq(2) }

    it "returns all the enablements" do
      expect(enablements.first.class).to eq(Jim::Enablements::Environment)
      expect(enablements.first.variable_name).to eq("SHELL")

      expect(enablements.second.class).to eq(Jim::Enablements::Ruby)
      expect(enablements.second.description).to include("Test from Feature spec")
    end
  end
end
