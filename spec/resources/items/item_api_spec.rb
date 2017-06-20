require 'spec_helper'

describe Elmas::Item do
  it "can initialize" do
    item = Elmas::Item.new
    expect(item).to be_a(Elmas::Item)
  end

  it "accepts attribute setter" do
    item = Elmas::Item.new
    item.code = "78238"
    expect(item.code).to eq "78238"
  end

  it "returns value for getters" do
    item = Elmas::Item.new({ "Code" => "345" })
    expect(item.code).to eq "345"
  end

  it "crashes and burns when getting an unset attribute" do
    item = Elmas::Item.new({ description: "Piet" })
    expect(item.try(:code)).to eq nil
  end

  it "is valid with mandatory attributes" do
    item = Elmas::Item.new(code: "23", description: "tralalala")
    expect(item.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    item = Elmas::Item.new
    expect(item.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::Item.new(id: "12abcdef-1234-1234-1234-123456abcdef", code: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("logistics/Items(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("logistics/Items?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("logistics/Items?$filter=Code+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:code, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("logistics/Items?$orderby=Code&$filter=Code+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:code, :id], order_by: :code)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("logistics/Items?$orderby=Code")
      resource.find_all(order_by: :code)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("logistics/Items?$select=Code")
      resource.find_all(select: [:code])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("logistics/Items?$select=Code")
      resource.find_by(select: [:code])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("logistics/Items?$select=Code,Id")
      resource.find_all(select: [:code, :id])
    end
  end
end
