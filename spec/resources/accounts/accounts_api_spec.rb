require 'spec_helper'

describe Elmas::Account do

  before do
    stub_request(:get, "https://start.exactonline.nl/api/v1//Current/Me").
       with(:headers => {'Accept'=>'application/response_format', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access_token', 'Content-Type'=>'application/response_format', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
  end

  it "can initialize" do
    account = Elmas::Account.new
    expect(account).to be_a(Elmas::Account)
  end

  it "accepts attribute setter" do
    account = Elmas::Account.new
    account.website = "website"
    expect(account.website).to eq "website"
  end

  it "returns value for getters" do
    account = Elmas::Account.new({ "Website" => "www.google.com" })
    expect(account.website).to eq "www.google.com"
  end

  it "crashes and burns when getting an unset attribute" do
    account = Elmas::Account.new({ name: "Piet" })
    expect(account.try(:birth_name)).to eq nil
  end

  it "does not allow to set an invalid attribute" do
    account = Elmas::Account.new
    account.airplane = "Boeing 777"
    expect(account.airplaine).to eq nil
  end
end
