require 'spec_helper'

describe Elmas::Transaction do
  it "can initialize" do
    transaction = Elmas::Transaction.new
    expect(transaction).to be_a(Elmas::Transaction)
  end

  it "accepts attribute setter" do
    transaction = Elmas::Transaction.new
    transaction.description = "78238"
    expect(transaction.description).to eq "78238"
  end

  it "returns value for getters" do
    transaction = Elmas::Transaction.new({ "AmountFC" => "345" })
    expect(transaction.amount_fc).to eq "345"
  end

  it "crashes and burns when getting an unset attribute" do
    transaction = Elmas::Transaction.new({ name: "Piet" })
    expect(transaction.try(:amount_FC)).to eq nil
  end

  let(:resource) { resource = Elmas::Transaction.new(id: "23", description: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("financialtransaction/Transactions(guid'23')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("financialtransaction/Transactions?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/Transactions?$filter=Description+eq+'1223'&$filter=ID+eq+guid'23'")
      resource.find_by(filters: [:description, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("financialtransaction/Transactions?$order_by=Description&$filter=Description+eq+'1223'&$filter=ID+eq+guid'23'")
      resource.find_by(filters: [:description, :id], order_by: :description)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/Transactions?$order_by=Description")
      resource.find_all(order_by: :description)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("financialtransaction/Transactions?$select=Description")
      resource.find_all(select: [:description])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("financialtransaction/Transactions?$select=Description")
      resource.find_by(select: [:description])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("financialtransaction/Transactions?$select=Description,Id")
      resource.find_all(select: [:description, :id])
    end
  end
end
