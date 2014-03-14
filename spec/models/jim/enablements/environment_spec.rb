require 'spec_helper'

describe Jim::Enablements::Environment do
  subject(:enablement) { Jim::Enablements::Environment.new(arguments) }
  let(:arguments) { { variable_name: "SHELL", matching: /.+/ } }

  describe "accessors" do
    its(:variable_name) { should eq("SHELL") }
    its(:regex) { should eq(/.+/) }
    its(:redact_value) { should be_false }
  end

  describe "#value" do
    subject { enablement.value }

    context "by default" do
      it { should eq(ENV["SHELL"]) }
    end

    context "when redact_value is false" do
      before { arguments[:redact_value] = false }
      it { should eq(ENV["SHELL"]) }
    end

    context "when redact_value is true" do
      before { arguments[:redact_value] = true }
      it { should be_nil }
    end
  end

  describe "#enabled?" do
    let(:arguments) { { variable_name: "test_enablement", matching: /^hello$/ } }
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
