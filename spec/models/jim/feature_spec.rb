require 'spec_helper'

class FeatureSpecEnablement
  def self.enable?
    true
  end

  def self.description
    "Test from Feature spec"
  end
end

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
