require 'spec_helper'

describe Jim::FeatureManager do
  let(:feature_manager) { Jim::FeatureManager.new(feature_hash) }
  let(:feature_hash) do
    { "features" => [
      { "id" => "time_travel", "description" => "Travel through time!", "depends_on" => "delorean" },
      { "id" => "space_travel", "description" => "Travel through space!" },
      { "id" => "delorean", "description" => "Shiny car" }
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

  describe "enabled?" do
    subject { feature_manager.enabled?(feature_id) }

    context "passed a unknown feature ID" do
      let(:feature_id) { :bad }

      it "explodes helpfully" do
        expect { subject }.to raise_error(Jim::UnknownFeatureError, /bad/)
      end
    end

    context "passed a known feature ID" do
      let(:feature_id) { :time_travel }

      context "when the feature is enabled" do
        it { should be true }
      end

      context "when the feature is disabled" do
        before { feature_manager.find_by_id(:time_travel).stub(enabled?: false) }
        it { should be false }
      end
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

    its(:length) { should eq(3) }

    describe "the first one" do
      subject(:feature) { features.first }

      its(:id) { should eq(:time_travel) }
      its(:description) { should include("Travel through time!") }

      describe "depends_on" do
        subject { feature.depended_on }

        its(:length) { should eq(1) }
        its("first.id") { should eq(:delorean) }

        context "depending on multiple features" do
          before { time_travel["depends_on"] = [ "delorean", "space_travel" ] }

          its(:length) { should eq(2) }
          its("second.id") { should eq(:space_travel) }
        end
      end
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
      its("first.description") { should include("Description") }
    end

    context "passed an array of features" do
      before do
        feature_manager.add_dependency(
          [ :time_travel, :space_travel],
          "Name",
          "Description"
        )
      end

      it "adds itself as a dependency to both features" do
        expect(feature_manager.find_by_id(:time_travel).dependants.length).to eq(1)
        expect(feature_manager.find_by_id(:space_travel).dependants.length).to eq(1)
      end
    end
  end
end
