require 'spec_helper'

describe Elmas::Document do

  before do
    stub_request(:get, "https://start.exactonline.nl/api/v1//Current/Me").
       with(:headers => {'Accept'=>'application/response_format', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access_token', 'Content-Type'=>'application/response_format', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
  end

  it "can initialize" do
    document = Elmas::Document.new
    expect(document).to be_a(Elmas::Document)
  end

  it "returns value for getters" do
    document = Elmas::Document.new({ "Account" => "345" })
    expect(document.account).to eq "345"
  end

  it "crashes and burns when getting an unset attribute" do
    document = Elmas::Document.new({ name: "Piet" })
    expect(document.try(:account)).to eq nil
  end

  it "is valid with certain attributes" do
    document = Elmas::Document.new({ subject: "BAM", type: 2 })
    expect(document.valid?).to eq(true)
  end

  it "is not valid without certain attributes" do
    document = Elmas::Document.new
    expect(document.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::Document.new(id: "12abcdef-1234-1234-1234-123456abcdef", account: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("documents/Documents(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("documents/Documents?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("documents/Documents?$filter=Account+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:account, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("documents/Documents?$orderby=Account&$filter=Account+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:account, :id], order_by: :account)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("documents/Documents?$orderby=Account")
      resource.find_all(order_by: :account)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("documents/Documents?$select=Account")
      resource.find_all(select: [:account])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("documents/Documents?$select=Account")
      resource.find_by(select: [:account])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("documents/Documents?$select=Account,Id")
      resource.find_all(select: [:account, :id])
    end
  end
end
