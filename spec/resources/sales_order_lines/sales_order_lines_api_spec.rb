require 'spec_helper'

describe Elmas::SalesOrderLine do
  it "can initialize" do
    sales_order_line = Elmas::SalesOrderLine.new
    expect(sales_order_line).to be_a(Elmas::SalesOrderLine)
  end

  it "accepts attribute setter" do
    sales_order_line = Elmas::SalesOrderLine.new
    sales_order_line.order_number = "78238"
    expect(sales_order_line.order_number).to eq "78238"
  end

  it "returns value for getters" do
    sales_order_line = Elmas::SalesOrderLine.new({ "OrderNumber" => "277" })
    expect(sales_order_line.order_number).to eq "277"
  end

  it "crashes and burns when getting an unset attribute" do
    sales_order_line = Elmas::SalesOrderLine.new({ item: "Piet" })
    expect(sales_order_line.try(:order_number)).to eq nil
  end

  #customer journal salesentrylines
  it "is valid with mandatory attributes" do
    sales_order_line = Elmas::SalesOrderLine.new(order_ID: "123878", item: "i2u3")
    expect(sales_order_line.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    sales_order_line = Elmas::SalesOrderLine.new
    expect(sales_order_line.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::SalesOrderLine.new(id: "12abcdef-1234-1234-1234-123456abcdef", order_number: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrderLines(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrderLines?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrderLines?$filter=OrderNumber+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:order_number, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrderLines?$orderby=OrderNumber&$filter=OrderNumber+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:order_number, :id], order_by: :order_number)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrderLines?$orderby=OrderNumber")
      resource.find_all(order_by: :order_number)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrderLines?$select=OrderNumber")
      resource.find_all(select: [:order_number])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrderLines?$select=OrderNumber")
      resource.find_by(select: [:order_number])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("salesorder/SalesOrderLines?$select=OrderNumber,Id")
      resource.find_all(select: [:order_number, :id])
    end
  end
end
