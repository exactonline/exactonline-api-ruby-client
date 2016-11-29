require 'spec_helper'

describe Elmas::SalesOrder do

  before do
    stub_request(:get, "https://start.exactonline.nl/api/v1//Current/Me").
       with(:headers => {'Accept'=>'application/response_format', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access_token', 'Content-Type'=>'application/response_format', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
  end

  it "can initialize" do
    sales_order = Elmas::SalesOrder.new
    expect(sales_order).to be_a(Elmas::SalesOrder)
  end

  it "accepts attribute setter" do
    sales_order = Elmas::SalesOrder.new
    sales_order.order_number = "78238"
    expect(sales_order.order_number).to eq "78238"
  end

  it "returns value for getters" do
    sales_order = Elmas::SalesOrder.new({ "OrderNumber" => "277" })
    expect(sales_order.order_number).to eq "277"
  end

  it "crashes and burns when getting an unset attribute" do
    sales_order = Elmas::SalesOrder.new({ name: "Piet" })
    expect(sales_order.try(:order_number)).to eq nil
  end

  #customer journal salesentrylines
  it "is valid with mandatory attributes" do
    sales_order = Elmas::SalesOrder.new(sales_order_lines: ["b","a"], ordered_by: "dsasds")
    expect(sales_order.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    sales_order = Elmas::SalesOrder.new
    expect(sales_order.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::SalesOrder.new(id: "12abcdef-1234-1234-1234-123456abcdef", order_number: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrders(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrders?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrders?$filter=OrderNumber+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:order_number, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrders?$orderby=OrderNumber&$filter=OrderNumber+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:order_number, :id], order_by: :order_number)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrders?$orderby=OrderNumber")
      resource.find_all(order_by: :order_number)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrders?$select=OrderNumber")
      resource.find_all(select: [:order_number])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrders?$select=OrderNumber")
      resource.find_by(select: [:order_number])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrders?$select=OrderNumber,Id")
      resource.find_all(select: [:order_number, :id])
    end
  end
end
