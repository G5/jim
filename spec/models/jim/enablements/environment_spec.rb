require 'spec_helper'

describe Jim::Enablements::Environment do
  describe "accessors" do
    subject do
      Jim::Enablements::Environment.new("SHELL", /.+/)
    end

    its(:variable_name) { should eq("SHELL") }
    its(:regex) { should eq(/.+/) }
    its(:redact_value) { should be_false }
  end

  describe "#value" do
    subject { enablement.value }

    context "by default" do
      let(:enablement) do
        Jim::Enablements::Environment.new("SHELL", /.+/)
      end

      it { should eq(ENV["SHELL"]) }
    end

    context "when redact_value is false" do
      let(:enablement) do
        Jim::Enablements::Environment.new("SHELL", /.+/, false)
      end

      it { should eq(ENV["SHELL"]) }
    end

    context "when redact_value is true" do
      let(:enablement) do
        Jim::Enablements::Environment.new("SHELL", /.+/, true)
      end

      it { should be_nil }
    end
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
