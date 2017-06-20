require 'spec_helper'

describe Elmas::AgingReceivablesList do
  it "can initialize" do
    sales_invoice = Elmas::AgingReceivablesList.new
    expect(sales_invoice).to be_a(Elmas::AgingReceivablesList)
  end

  it "is valid without attributes" do
    sales_invoice = Elmas::AgingReceivablesList.new
    expect(sales_invoice.valid?).to eq(true)
  end

  it "is valid with attributes" do
    sales_invoice = Elmas::AgingReceivablesList.new(age_group4: "abc-def")
    expect(sales_invoice.valid?).to eq(true)
  end

  context "Applying filters" do
    resource = Elmas::AgingReceivablesList.new(id: '12abcdef-1234-1234-1234-123456abcdef')
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("read/financial/AgingReceivablesList(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      resource = Elmas::AgingReceivablesList.new(total_amount: 2)
      expect(Elmas).to receive(:get).with("read/financial/AgingReceivablesList?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      resource = Elmas::AgingReceivablesList.new(id: "12abcdef-1234-1234-1234-123456abcdef", total_amount: "2")
      expect(Elmas).to receive(:get).with("read/financial/AgingReceivablesList?$filter=TotalAmount+eq+'2'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:total_amount, :id])
    end
  end
end
