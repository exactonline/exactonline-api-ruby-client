require 'spec_helper'

describe Elmas::PurchaseEntry do
  it "can initialize" do
    purchase_entry = Elmas::PurchaseEntry.new
    expect(purchase_entry).to be_a(Elmas::PurchaseEntry)
  end

  it "accepts attribute setter" do
    purchase_entry = Elmas::PurchaseEntry.new
    purchase_entry.batch_number = "78238"
    expect(purchase_entry.batch_number).to eq "78238"
  end

  it "returns value for getters" do
    purchase_entry = Elmas::PurchaseEntry.new({ "BatchNumber" => "277" })
    expect(purchase_entry.batch_number).to eq "277"
  end

  it "crashes and burns when getting an unset attribute" do
    purchase_entry = Elmas::PurchaseEntry.new({ journal: "Piet" })
    expect(purchase_entry.try(:batch_number)).to eq nil
  end

  #customer journal salesentrylines
  it "is valid with mandatory attributes" do
    purchase_entry = Elmas::PurchaseEntry.new(supplier: "82378ks", journal: "my-awesome-journal", purchase_entry_lines: ["b","a"])
    expect(purchase_entry.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    purchase_entry = Elmas::PurchaseEntry.new
    expect(purchase_entry.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::PurchaseEntry.new(id: "12abcdef-1234-1234-1234-123456abcdef", batch_number: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("purchaseentry/PurchaseEntries(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("purchaseentry/PurchaseEntries?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("purchaseentry/PurchaseEntries?$filter=BatchNumber+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:batch_number, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("purchaseentry/PurchaseEntries?$orderby=BatchNumber&$filter=BatchNumber+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:batch_number, :id], order_by: :batch_number)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("purchaseentry/PurchaseEntries?$orderby=BatchNumber")
      resource.find_all(order_by: :batch_number)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("purchaseentry/PurchaseEntries?$select=BatchNumber")
      resource.find_all(select: [:batch_number])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("purchaseentry/PurchaseEntries?$select=BatchNumber")
      resource.find_by(select: [:batch_number])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("purchaseentry/PurchaseEntries?$select=BatchNumber,Id")
      resource.find_all(select: [:batch_number, :id])
    end
  end
end
