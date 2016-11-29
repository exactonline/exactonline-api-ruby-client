require 'spec_helper'

describe Elmas::Mailbox do

  before do
    stub_request(:get, "https://start.exactonline.nl/api/v1//Current/Me").
       with(:headers => {'Accept'=>'application/response_format', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access_token', 'Content-Type'=>'application/response_format', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
  end

  it "can initialize" do
    mailbox = Elmas::Mailbox.new
    expect(mailbox).to be_a(Elmas::Mailbox)
  end

  it "accepts attribute setter" do
    mailbox = Elmas::Mailbox.new
    mailbox.account = "78238"
    expect(mailbox.account).to eq "78238"
  end

  it "returns value for getters" do
    mailbox = Elmas::Mailbox.new({ "Account" => "345" })
    expect(mailbox.account).to eq "345"
  end

  it "crashes and burns when getting an unset attribute" do
    mailbox = Elmas::Mailbox.new({ mailbox: "Karel@APPEL.COM" })
    expect(mailbox.try(:account)).to eq nil
  end

  it "is not valid without attributes" do
    mailbox = Elmas::Mailbox.new
    expect(mailbox.valid?).to eq(false)
  end

  it "is valid with mailbox attribute" do
    mailbox = Elmas::Mailbox.new(mailbox: "Marthyn@Live.nl")
    expect(mailbox.valid?).to eq(true)
  end

  let(:resource) { resource = Elmas::Mailbox.new(id: "12abcdef-1234-1234-1234-123456abcdef", account: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes?$filter=Account+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:account, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes?$orderby=Account&$filter=Account+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:account, :id], order_by: :account)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes?$orderby=Account")
      resource.find_all(order_by: :account)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes?$select=Account")
      resource.find_all(select: [:account])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes?$select=Account")
      resource.find_by(select: [:account])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes?$select=Account,Id")
      resource.find_all(select: [:account, :id])
    end
  end
end
