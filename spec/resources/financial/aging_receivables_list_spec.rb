require 'spec_helper'

describe Elmas::AgingReceivablesList do

  before do
    stub_request(:get, "https://start.exactonline.nl/api/v1//Current/Me").
       with(:headers => {'Accept'=>'application/response_format', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access_token', 'Content-Type'=>'application/response_format', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
  end

  it "can initialize" do
    sales_invoice = Elmas::AgingReceivablesList.new
    expect(sales_invoice).to be_a(Elmas::AgingReceivablesList)
  end

  it "is valid without attributes" do
    sales_invoice = Elmas::AgingReceivablesList.new
    expect(sales_invoice.valid?).to eq(true)
  end

  it "is valid with attributes" do
    sales_invoice = Elmas::AgingReceivablesList.new(invoice_ID: "abc-def")
    expect(sales_invoice.valid?).to eq(true)
  end

  context "Applying filters" do
    resource = Elmas::AgingReceivablesList.new(id: '12abcdef-1234-1234-1234-123456abcdef')
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("read/financial/AgingReceivablesList(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      resource = Elmas::AgingReceivablesList.new(type: 2)
      expect(Elmas).to receive(:get).with("read/financial/AgingReceivablesList?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      resource = Elmas::AgingReceivablesList.new(id: "12abcdef-1234-1234-1234-123456abcdef", type: "2")
      expect(Elmas).to receive(:get).with("read/financial/AgingReceivablesList?$filter=Type+eq+'2'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:type, :id])
    end
  end
end
