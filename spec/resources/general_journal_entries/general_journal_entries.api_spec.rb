require 'spec_helper'

describe Elmas::GeneralJournalEntry do

  before do
    stub_request(:get, "https://start.exactonline.nl/api/v1//Current/Me").
       with(:headers => {'Accept'=>'application/response_format', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access_token', 'Content-Type'=>'application/response_format', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
  end

  it "can initialize" do
    general_journal_entry = Elmas::GeneralJournalEntry.new
    expect(general_journal_entry).to be_a(Elmas::GeneralJournalEntry)
  end

  it "accepts attribute setter" do
    general_journal_entry = Elmas::GeneralJournalEntry.new
    general_journal_entry.financial_year = 2016
    expect(general_journal_entry.financial_year).to eq 2016
  end

  it "returns value for getters" do
    general_journal_entry = Elmas::GeneralJournalEntry.new({ "FinancialYear" => 2016 })
    expect(general_journal_entry.financial_year).to eq 2016
  end

  it "crashes and burns when getting an unset attribute" do
    general_journal_entry = Elmas::GeneralJournalEntry.new({ name: "Piet" })
    expect(general_journal_entry.try(:financial_year)).to eq nil
  end

  it "is valid with mandatory attributes" do
    general_journal_entry = Elmas::GeneralJournalEntry.new(journal_code: 91, currency: 'EUR', general_journal_entry_lines: ["b","a"])
    expect(general_journal_entry.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    general_journal_entry = Elmas::GeneralJournalEntry.new
    expect(general_journal_entry.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::GeneralJournalEntry.new(id: "12abcdef-1234-1234-1234-123456abcdef", financial_year: 2016) }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntries(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntries?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntries?$filter=FinancialYear+eq+2016&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:financial_year, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntries?$orderby=FinancialYear&$filter=FinancialYear+eq+2016&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:financial_year, :id], order_by: :financial_year)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntries?$orderby=FinancialYear")
      resource.find_all(order_by: :financial_year)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntries?$select=FinancialYear")
      resource.find_all(select: [:financial_year])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntries?$select=FinancialYear")
      resource.find_by(select: [:financial_year])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntries?$select=FinancialYear,Id")
      resource.find_all(select: [:financial_year, :id])
    end
  end
end
