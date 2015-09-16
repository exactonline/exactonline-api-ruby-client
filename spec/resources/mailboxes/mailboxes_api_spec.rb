require 'spec_helper'

describe Elmas::Mailbox do
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

  let(:resource) { resource = Elmas::Mailbox.new(id: "23", account: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes(guid'23')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes?$filter=Account+eq+'1223'&$filter=ID+eq+guid'23'")
      resource.find_by(filters: [:account, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes?$order_by=Account&$filter=Account+eq+'1223'&$filter=ID+eq+guid'23'")
      resource.find_by(filters: [:account, :id], order_by: :account)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("mailbox/Mailboxes?$order_by=Account")
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
