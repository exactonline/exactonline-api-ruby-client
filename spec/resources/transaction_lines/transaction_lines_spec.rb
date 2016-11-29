require 'spec_helper'

describe Elmas::TransactionLine do

  before do
    stub_request(:get, "https://start.exactonline.nl/api/v1//Current/Me").
       with(:headers => {'Accept'=>'application/response_format', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access_token', 'Content-Type'=>'application/response_format', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
  end


  it "can initialize" do
    transaction_line = Elmas::TransactionLine.new
    expect(transaction_line).to be_a(Elmas::TransactionLine)
  end

  it "accepts attribute setter" do
    transaction_line = Elmas::TransactionLine.new
    transaction_line.asset_code = "78238"
    expect(transaction_line.asset_code).to eq "78238"
  end

  it "returns value for getters" do
    transaction_line = Elmas::TransactionLine.new({ "AmountFC" => "345" })
    expect(transaction_line.amount_fc).to eq "345"
  end

  it "crashes and burns when getting an unset attribute" do
    transaction_line = Elmas::TransactionLine.new({ name: "Piet" })
    expect(transaction_line.try(:amount_FC)).to eq nil
  end

  let(:resource) { resource = Elmas::TransactionLine.new(id: "12abcdef-1234-1234-1234-123456abcdef", asset_code: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("financialtransaction/TransactionLines(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("financialtransaction/TransactionLines?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/TransactionLines?$filter=AssetCode+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:asset_code, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("financialtransaction/TransactionLines?$orderby=AssetCode&$filter=AssetCode+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:asset_code, :id], order_by: :asset_code)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/TransactionLines?$orderby=AssetCode")
      resource.find_all(order_by: :asset_code)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("financialtransaction/TransactionLines?$select=AssetCode")
      resource.find_all(select: [:asset_code])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/TransactionLines?$select=AssetCode")
      resource.find_by(select: [:asset_code])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("financialtransaction/TransactionLines?$select=AssetCode,Id")
      resource.find_all(select: [:asset_code, :id])
    end
  end
end
