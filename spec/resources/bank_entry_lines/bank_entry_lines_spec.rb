require 'spec_helper'

describe Elmas::BankEntryLine do
  it "can initialize" do
    bank_entry_line = Elmas::BankEntryLine.new
    expect(bank_entry_line).to be_a(Elmas::BankEntryLine)
  end

  it "accepts attribute setter" do
    bank_entry_line = Elmas::BankEntryLine.new
    bank_entry_line.our_ref = "78238"
    expect(bank_entry_line.our_ref).to eq "78238"
  end

  it "returns value for getters" do
    bank_entry_line = Elmas::BankEntryLine.new({ "VATPercentage" => "345" })
    expect(bank_entry_line.VAT_percentage).to eq "345"
  end

  it "crashes and burns when getting an unset attribute" do
    bank_entry_line = Elmas::BankEntryLine.new({ project: "Piet" })
    expect(bank_entry_line.try(:amount_VATFC)).to eq nil
  end

  #customer journal salesentrylines
  it "is valid with mandatory attributes" do
    bank_entry_line = Elmas::BankEntryLine.new(amount_FC: "23", entry_ID: "23299ask-2233", GL_account: "sdjkj29")
    expect(bank_entry_line.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    bank_entry_line = Elmas::BankEntryLine.new
    expect(bank_entry_line.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::BankEntryLine.new(id: "12abcdef-1234-1234-1234-123456abcdef", our_ref: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntryLines(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntryLines?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntryLines?$filter=OurRef+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:our_ref, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntryLines?$orderby=OurRef&$filter=OurRef+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:our_ref, :id], order_by: :our_ref)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntryLines?$orderby=OurRef")
      resource.find_all(order_by: :our_ref)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntryLines?$select=OurRef")
      resource.find_all(select: [:our_ref])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntryLines?$select=OurRef")
      resource.find_by(select: [:our_ref])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntryLines?$select=OurRef,Id")
      resource.find_all(select: [:our_ref, :id])
    end
  end
end
