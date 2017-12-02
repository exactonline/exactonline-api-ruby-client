require 'spec_helper'

describe Elmas::Contact do
  it "can initialize" do
    contact = Elmas::Contact.new
    expect(contact).to be_a(Elmas::Contact)
  end

  it "accepts attribute setter" do
    contact = Elmas::Contact.new
    contact.first_name = "Karel"
    expect(contact.first_name).to eq "Karel"
  end

  it "returns value for getters" do
    contact = Elmas::Contact.new({ "BirthName" => "Karel" })
    expect(contact.birth_name).to eq "Karel"
  end

  it "crashes and burns when getting an unset attribute" do
    contact = Elmas::Contact.new({ account_name: "Piet" })
    expect(contact.try(:birth_name)).to eq nil
  end

  context "Applying filters" do
    it "should apply ID filter for find" do
      resource = Elmas::Contact.new(id: "12abcdef-1234-1234-1234-123456abcdef")
      expect(Elmas).to receive(:get).with("crm/Contacts(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      resource = Elmas::Contact.new(id: "12abcdef-1234-1234-1234-123456abcdef", account_name: "Karel")
      expect(Elmas).to receive(:get).with("crm/Contacts?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      resource = Elmas::Contact.new(id: "12abcdef-1234-1234-1234-123456abcdef", account_name: "Karel")
      expect(Elmas).to receive(:get).with("crm/Contacts?$filter=AccountName+eq+'Karel'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:account_name, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      resource = Elmas::Contact.new(id: "12abcdef-1234-1234-1234-123456abcdef", account_name: "Karel")
      expect(Elmas).to receive(:get).with("crm/Contacts?$orderby=AccountName&$filter=AccountName+eq+'Karel'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:account_name, :id], order_by: :account_name)
    end

    it "should only apply the order_by" do
      resource = Elmas::Contact.new(id: "12abcdef-1234-1234-1234-123456abcdef", account_name: "Karel")
      expect(Elmas).to receive(:get).with("crm/Contacts?$orderby=AccountName")
      resource.find_all(order_by: :account_name)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      resource = Elmas::Contact.new(id: "12abcdef-1234-1234-1234-123456abcdef", account_name: "Karel")
      expect(Elmas).to receive(:get).with("crm/Contacts?$select=AccountName")
      resource.find_all(select: [:account_name])
    end

    it "should apply one select with find_by" do
      resource = Elmas::Contact.new(id: "12abcdef-1234-1234-1234-123456abcdef", account_name: "Karel")
      expect(Elmas).to receive(:get).with("crm/Contacts?$select=AccountName")
      resource.find_by(select: [:account_name])
    end

    it "should apply one select" do
      resource = Elmas::Contact.new(id: "12abcdef-1234-1234-1234-123456abcdef", account_name: "Karel")
      expect(Elmas).to receive(:get).with("crm/Contacts?$select=AccountName,Age")
      resource.find_all(select: [:account_name, :age])
    end
  end
end
