require 'spec_helper'

describe Jim::Enablements::Environment do
  describe "accessors" do
    subject do
      Jim::Enablements::Environment.new("SHELL", /.+/ )
    end

    its(:variable_name) { should eq("SHELL") }
    its(:regex) { should eq(/.+/) }
    its(:value) { should eq(ENV["SHELL"]) }
  end

  describe "#enabled?" do
    let(:enablement) do
      Jim::Enablements::Environment.new(
        "test_enablement",
        /^hello$/
      )
    end
    subject { enablement.enabled? }
    after { ENV.delete("test_enablement") }

    context "when the ENV var is not set" do
      it { should be_false }
    end

    context "when the ENV var doesn't match" do
      before { ENV["test_enablement"] = "ello" }
      it { should be_false }
    end

    context "when the ENV var matches" do
      before { ENV["test_enablement"] = "hello" }
      it { should be_true }
    end
  end
end
