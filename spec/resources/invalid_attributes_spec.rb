require 'spec_helper'

describe "Handling invalid attributes" do
  it "raises an error when you try to set invalid attributes" do
    expect { Elmas::Account.new(not_a_valid_attribute: "string") }.to raise_error(Elmas::InvalidAttributeException)
  end

  it "returns a valid object when you set only valid attributes" do
    expect { Elmas::Account.new(code: "string") }.to_not raise_error(Elmas::InvalidAttributeException)
  end
end
