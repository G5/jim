require 'spec_helper'

describe Jim::FeatureManager do
  let(:feature_manager) { Jim::FeatureManager.new(feature_hash) }
  let(:feature_hash) do
    { "features" => [
      { "id" => "time_travel", "description" => "Travel through time!" }
    ]}
  end

  describe ".instance" do
    it "returns the same instance" do
      expect(Jim::FeatureManager.instance).to equal(Jim::FeatureManager.instance)
    end

    it "instantiates the FeatureManager with the YAML config file" do
      expect(Jim::FeatureManager.instance.features.first["id"]).to eql("time_travel")
    end
  end

  describe "#enabled?" do
    subject(:enabled) { feature_manager.enabled?(:time_travel) }

    context "passed an unknown feature ID" do
      let(:feature_hash) { { "features" => [] } }

      it "blows up real good" do
        expect { enabled }.to raise_error(Jim::UnknownFeatureError, /time_travel/)
      end
    end

    context "passed a known feature ID" do
      context "that has not been enabled" do
        it { should be_false }
      end

      context "that has been enabled" do
        before { feature_manager.enable(:time_travel) }
        it { should be_true }
      end
    end
  end

  describe "#features" do
    subject { feature_manager.features }

    it { should eql(feature_hash["features"]) }
  end
end
