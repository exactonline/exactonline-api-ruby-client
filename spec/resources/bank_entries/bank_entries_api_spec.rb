require 'spec_helper'

describe Elmas::BankEntry do
  it "can initialize" do
    sales_entry = Elmas::BankEntry.new
    expect(sales_entry).to be_a(Elmas::BankEntry)
  end

  it "accepts attribute setter" do
    sales_entry = Elmas::BankEntry.new
    sales_entry.financial_year = "78238"
    expect(sales_entry.financial_year).to eq "78238"
  end

  it "returns value for getters" do
    sales_entry = Elmas::BankEntry.new({ "FinancialYear" => "277" })
    expect(sales_entry.financial_year).to eq "277"
  end

  it "crashes and burns when getting an unset attribute" do
    sales_entry = Elmas::BankEntry.new({ journal_code: "232332" })
    expect(sales_entry.try(:financial_year)).to eq nil
  end

  #customer journal salesentrylines
  it "is valid with mandatory attributes" do
    sales_entry = Elmas::BankEntry.new(journal_code: "Awesome", bank_entry_lines: ["sds", "sdas"])
    expect(sales_entry.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    sales_entry = Elmas::BankEntry.new
    expect(sales_entry.valid?).to eq(false)
  end

  let(:resource) {
    Elmas::BankEntry.new(
      id: "12abcdef-1234-1234-1234-123456abcdef",
      financial_year: "1223",
      created: { ge: Date.new(2016, 6, 1) },
      modified: { lt: DateTime.new(2016, 12, 31, 13, 37) }
    )
  }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntries(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntries?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntries?$filter=FinancialYear+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:financial_year, :id])
    end

    it "should apply date and time filters for find_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntries?$filter=Created+ge+datetime'2016-06-01T00:00:00Z'&$filter=Modified+lt+datetime'2016-12-31T13:37:00Z'")
      resource.find_by(filters: [:created, :modified])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntries?$orderby=FinancialYear&$filter=FinancialYear+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:financial_year, :id], order_by: :financial_year)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntries?$orderby=FinancialYear")
      resource.find_all(order_by: :financial_year)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntries?$select=FinancialYear")
      resource.find_all(select: [:financial_year])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntries?$select=FinancialYear")
      resource.find_by(select: [:financial_year])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("financialtransaction/BankEntries?$select=FinancialYear,Id")
      resource.find_all(select: [:financial_year, :id])
    end
  end
end
