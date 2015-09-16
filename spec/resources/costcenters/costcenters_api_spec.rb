require 'spec_helper'

describe Elmas::Costcenter do
  it "can initialize" do
    costcenter = Elmas::Costcenter.new
    expect(costcenter).to be_a(Elmas::Costcenter)
  end

  it "accepts attribute setter" do
    costcenter = Elmas::Costcenter.new
    costcenter.code = "78238"
    expect(costcenter.code).to eq "78238"
  end

  it "returns value for getters" do
    costcenter = Elmas::Costcenter.new({ "Code" => "345" })
    expect(costcenter.code).to eq "345"
  end

  it "crashes and burns when getting an unset attribute" do
    costcenter = Elmas::Costcenter.new({ name: "Piet" })
    expect(costcenter.try(:code)).to eq nil
  end

  it "is valid with mandatory attributes" do
    costcenter = Elmas::Costcenter.new(code: "23", description: "tralalala")
    expect(costcenter.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    costcenter = Elmas::Costcenter.new
    expect(costcenter.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::Costcenter.new(id: "23", code: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("hrm/Costcenters(guid'23')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("hrm/Costcenters?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("hrm/Costcenters?$filter=Code+eq+'1223'&$filter=ID+eq+guid'23'")
      resource.find_by(filters: [:code, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("hrm/Costcenters?$order_by=Code&$filter=Code+eq+'1223'&$filter=ID+eq+guid'23'")
      resource.find_by(filters: [:code, :id], order_by: :code)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("hrm/Costcenters?$order_by=Code")
      resource.find_all(order_by: :code)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("hrm/Costcenters?$select=Code")
      resource.find_all(select: [:code])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("hrm/Costcenters?$select=Code")
      resource.find_by(select: [:code])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("hrm/Costcenters?$select=Code,Id")
      resource.find_all(select: [:code, :id])
    end
  end
end
