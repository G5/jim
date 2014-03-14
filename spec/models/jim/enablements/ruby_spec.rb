require 'spec_helper'

class TestTrueRubyEnablement
  def self.enable?
    true
  end
end

class TestFalseRubyEnablement
  def self.enable?
    false
  end
end

class TestNoDescriptionEnablement
  def self.enable?
    false
  end
end

class TestDescriptionEnablement
  def self.enable?
    false
  end

  def self.description
    "Test description"
  end
end

describe Jim::Enablements::Ruby do
  let(:enablement) { Jim::Enablements::Ruby.new(class_name) }

  describe "#description" do
    subject { enablement.description }

    context "when the class defines a description" do
      let(:class_name) { "TestDescriptionEnablement" }
      it { should eq(TestDescriptionEnablement.description) }
    end

    context "when the class defines no description" do
      let(:class_name) { "TestNoDescriptionEnablement" }
      it { should be_nil }
    end
  end

  describe "#enabled?" do
    subject { enablement.enabled? }

    context "when the class can't be found" do
      let(:class_name) { "BadClassName" }

      it "raises a helpful error" do
        expect { subject }.to raise_error(/BadClassName/)
      end
    end

    context "when the class can be found" do
      context "when its #enabled? is false" do
        let(:class_name) { "TestFalseRubyEnablement" }
        it { should be_false }
      end

      context "when its #enabled? is true" do
        let(:class_name) { "TestTrueRubyEnablement" }
        it { should be_true }
      end
    end
  end
end
