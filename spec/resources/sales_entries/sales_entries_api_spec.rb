require 'spec_helper'

describe Elmas::SalesEntry do

  before do
    stub_request(:get, "https://start.exactonline.nl/api/v1//Current/Me").
       with(:headers => {'Accept'=>'application/response_format', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access_token', 'Content-Type'=>'application/response_format', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
  end

  it "can initialize" do
    sales_entry = Elmas::SalesEntry.new
    expect(sales_entry).to be_a(Elmas::SalesEntry)
  end

  it "accepts attribute setter" do
    sales_entry = Elmas::SalesEntry.new
    sales_entry.batch_number = "78238"
    expect(sales_entry.batch_number).to eq "78238"
  end

  it "returns value for getters" do
    sales_entry = Elmas::SalesEntry.new({ "BatchNumber" => "277" })
    expect(sales_entry.batch_number).to eq "277"
  end

  it "crashes and burns when getting an unset attribute" do
    sales_entry = Elmas::SalesEntry.new({ name: "Piet" })
    expect(sales_entry.try(:batch_number)).to eq nil
  end

  #customer journal salesentrylines
  it "is valid with mandatory attributes" do
    sales_entry = Elmas::SalesEntry.new(contact: "82378ks", journal: "my-awesome-journal", sales_entry_lines: ["b","a"])
    expect(sales_entry.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    sales_entry = Elmas::SalesEntry.new
    expect(sales_entry.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::SalesEntry.new(id: "12abcdef-1234-1234-1234-123456abcdef", batch_number: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntries(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntries?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntries?$filter=BatchNumber+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:batch_number, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntries?$orderby=BatchNumber&$filter=BatchNumber+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:batch_number, :id], order_by: :batch_number)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntries?$orderby=BatchNumber")
      resource.find_all(order_by: :batch_number)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntries?$select=BatchNumber")
      resource.find_all(select: [:batch_number])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntries?$select=BatchNumber")
      resource.find_by(select: [:batch_number])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("salesentry/SalesEntries?$select=BatchNumber,Id")
      resource.find_all(select: [:batch_number, :id])
    end
  end
end
