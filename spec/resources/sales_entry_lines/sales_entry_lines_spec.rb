require 'spec_helper'

describe Elmas::SalesEntryLine do
  it "can initialize" do
    sales_entry_line = Elmas::SalesEntryLine.new
    expect(sales_entry_line).to be_a(Elmas::SalesEntryLine)
  end

  it "accepts attribute setter" do
    sales_entry_line = Elmas::SalesEntryLine.new
    sales_entry_line.serial_number = "78238"
    expect(sales_entry_line.serial_number).to eq "78238"
  end

  it "returns value for getters" do
    sales_entry_line = Elmas::SalesEntryLine.new({ "AmountFC" => "345" })
    expect(sales_entry_line.amount_fc).to eq "345"
  end

  it "crashes and burns when getting an unset attribute" do
    sales_entry_line = Elmas::SalesEntryLine.new({ name: "Piet" })
    expect(sales_entry_line.try(:amount_FC)).to eq nil
  end

  #customer journal salesentrylines
  it "is valid with mandatory attributes" do
    sales_entry_line = Elmas::SalesEntryLine.new(amount_FC: "23", entry_ID: "23299ask-2233", GL_account: "sdjkj29")
    expect(sales_entry_line.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    sales_entry_line = Elmas::SalesEntryLine.new
    expect(sales_entry_line.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::SalesEntryLine.new(id: "23", serial_number: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntryLines(guid'23')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntryLines?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntryLines?$filter=SerialNumber+eq+'1223'&$filter=ID+eq+guid'23'")
      resource.find_by(filters: [:serial_number, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntryLines?$order_by=SerialNumber&$filter=SerialNumber+eq+'1223'&$filter=ID+eq+guid'23'")
      resource.find_by(filters: [:serial_number, :id], order_by: :serial_number)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntryLines?$order_by=SerialNumber")
      resource.find_all(order_by: :serial_number)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntryLines?$select=SerialNumber")
      resource.find_all(select: [:serial_number])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntryLines?$select=SerialNumber")
      resource.find_by(select: [:serial_number])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntryLines?$select=SerialNumber,Id")
      resource.find_all(select: [:serial_number, :id])
    end
  end
end
