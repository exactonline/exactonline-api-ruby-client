require 'spec_helper'

describe Elmas::VatCode do
  it "can initialize" do
    vat_code = Elmas::VatCode.new
    expect(vat_code).to be_a(Elmas::VatCode)
  end

  it "accepts attribute setter" do
    vat_code = Elmas::VatCode.new
    vat_code.code = "78238"
    expect(vat_code.code).to eq "78238"
  end

  it "returns value for getters" do
    vat_code = Elmas::VatCode.new({ "Code" => "345" })
    expect(vat_code.code).to eq "345"
  end

  it "crashes and burns when getting an unset attribute" do
    vat_code = Elmas::VatCode.new({ charged: "28" })
    expect(vat_code.try(:code)).to eq nil
  end

  it "is valid with mandatory attributes" do
    vat_code = Elmas::VatCode.new(code: "23", description: "tralalala")
    expect(vat_code.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    vat_code = Elmas::VatCode.new
    expect(vat_code.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::VatCode.new(id: "12abcdef-1234-1234-1234-123456abcdef", code: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("vat/VATCodes(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("vat/VATCodes?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("vat/VATCodes?$filter=Code+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:code, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("vat/VATCodes?$orderby=Code&$filter=Code+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:code, :id], order_by: :code)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("vat/VATCodes?$orderby=Code")
      resource.find_all(order_by: :code)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("vat/VATCodes?$select=Code")
      resource.find_all(select: [:code])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("vat/VATCodes?$select=Code")
      resource.find_by(select: [:code])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("vat/VATCodes?$select=Code,Id")
      resource.find_all(select: [:code, :id])
    end
  end
end
