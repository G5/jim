require 'spec_helper'

describe "root path" do
  it "redirects to features" do
    visit jim.root_path
    expect(current_path).to eq(jim.features_path)
  end
end
