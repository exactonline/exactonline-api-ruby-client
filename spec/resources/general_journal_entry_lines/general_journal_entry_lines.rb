require 'spec_helper'

describe Elmas::GeneralJournalEntryLine do

  before do
    stub_request(:get, "https://start.exactonline.nl/api/v1//Current/Me").
       with(:headers => {'Accept'=>'application/response_format', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access_token', 'Content-Type'=>'application/response_format', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
  end

  it "can initialize" do
    general_journal_entry_line = Elmas::GeneralJournalEntryLine.new
    expect(general_journal_entry_line).to be_a(Elmas::GeneralJournalEntryLine)
  end

  it "accepts attribute setter" do
    general_journal_entry_line = Elmas::GeneralJournalEntryLine.new
    general_journal_entry_line.serial_number = "78238"
    expect(general_journal_entry_line.serial_number).to eq "78238"
  end

  it "returns value for getters" do
    general_journal_entry_line = Elmas::GeneralJournalEntryLine.new({ "AmountFC" => "345" })
    expect(general_journal_entry_line.amount_fc).to eq "345"
  end

  it "crashes and burns when getting an unset attribute" do
    general_journal_entry_line = Elmas::GeneralJournalEntryLine.new({ name: "Piet" })
    expect(general_journal_entry_line.try(:amount_FC)).to eq nil
  end

  #customer journal GeneralJournalEntryLines
  it "is valid with mandatory attributes" do
    general_journal_entry_line = Elmas::GeneralJournalEntryLine.new(amount_FC: "23", entry_ID: "23299ask-2233", GL_account: "sdjkj29")
    expect(general_journal_entry_line.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    general_journal_entry_line = Elmas::GeneralJournalEntryLine.new
    expect(general_journal_entry_line.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::GeneralJournalEntryLine.new(id: "12abcdef-1234-1234-1234-123456abcdef", serial_number: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntryLines(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntryLines?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntryLines?$filter=SerialNumber+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:serial_number, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntryLines?$orderby=SerialNumber&$filter=SerialNumber+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:serial_number, :id], order_by: :serial_number)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntryLines?$orderby=SerialNumber")
      resource.find_all(order_by: :serial_number)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntryLines?$select=SerialNumber")
      resource.find_all(select: [:serial_number])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntryLines?$select=SerialNumber")
      resource.find_by(select: [:serial_number])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("generaljournalentry/GeneralJournalEntryLines?$select=SerialNumber,Id")
      resource.find_all(select: [:serial_number, :id])
    end
  end
end
