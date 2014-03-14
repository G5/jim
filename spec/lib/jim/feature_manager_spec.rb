require 'spec_helper'

describe Jim::FeatureManager do
  let(:feature_manager) { Jim::FeatureManager.new(feature_hash) }
  let(:feature_hash) do
    { "features" => [
      { "id" => "time_travel", "description" => "Travel through time!" }
    ]}
  end
  let(:time_travel) { feature_hash["features"].first }

  describe ".instance" do
    it "returns the same instance" do
      expect(Jim::FeatureManager.instance).to equal(Jim::FeatureManager.instance)
    end

    it "instantiates the FeatureManager with the YAML config file" do
      expect(Jim::FeatureManager.instance.features.first.id).to eql(:time_travel)
    end
  end

  describe "#find_by_id" do
    subject(:find) { feature_manager.find_by_id(:time_travel) }

    context "passed an unknown feature ID" do
      let(:feature_hash) { { "features" => [] } }

      it "blows up real good" do
        expect { find }.to raise_error(Jim::UnknownFeatureError, /time_travel/)
      end
    end

    context "passed a known feature ID" do
      its(:id) { should eq(:time_travel) }
    end
  end

  describe "#features" do
    subject(:features) { feature_manager.features }

    its(:length) { should eq(1) }

    describe "the first one" do
      subject { features.first }

      its(:id) { should eq(:time_travel) }
      its(:description) { should eq("Travel through time!") }
    end
  end

  describe "#add_dependency" do
    context "passed an unknown feature" do
      it "raises an UnknownFeatureError" do
        expect {
          feature_manager.add_dependency(:bad, "test", "test")
        }.to raise_error(Jim::UnknownFeatureError, /bad/)
      end
    end

    context "passed a known feature" do
      before do
        feature_manager.add_dependency(:time_travel, "Name", "Description")
      end
      subject { feature_manager.find_by_id(:time_travel).dependants }

      its(:length) { should eq(1) }
      its("first.name") { should eq("Name") }
      its("first.description") { should eq("Description") }
    end
  end
end
