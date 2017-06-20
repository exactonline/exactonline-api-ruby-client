require 'spec_helper'

describe Elmas::GLAccount do
  it "can initialize" do
    gl_account = Elmas::GLAccount.new
    expect(gl_account).to be_a(Elmas::GLAccount)
  end

  it "accepts attribute setter" do
    gl_account = Elmas::GLAccount.new
    gl_account.code = "78238"
    expect(gl_account.code).to eq "78238"
  end

  it "returns value for getters" do
    gl_account = Elmas::GLAccount.new({ "Code" => "345" })
    expect(gl_account.code).to eq "345"
  end

  it "crashes and burns when getting an unset attribute" do
    gl_account = Elmas::GLAccount.new({ description: "Piet" })
    expect(gl_account.try(:code)).to eq nil
  end

  #customer journal salesentrylines
  it "is valid with mandatory attributes" do
    gl_account = Elmas::GLAccount.new(code: "23", description: "The 24th of september was a special day")
    expect(gl_account.valid?).to eq(true)
  end

  it "is not valid without mandatory attributes" do
    gl_account = Elmas::GLAccount.new
    expect(gl_account.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::GLAccount.new(id: "12abcdef-1234-1234-1234-123456abcdef", code: "1223", description: "IT IS NOT REAL") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("financial/GLAccounts(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("financial/GLAccounts?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("financial/GLAccounts?$filter=Code+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:code, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("financial/GLAccounts?$orderby=Code&$filter=Code+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:code, :id], order_by: :code)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("financial/GLAccounts?$orderby=Code")
      resource.find_all(order_by: :code)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("financial/GLAccounts?$select=Code")
      resource.find_all(select: [:code])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("financial/GLAccounts?$select=Code")
      resource.find_by(select: [:code])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("financial/GLAccounts?$select=Code,Id")
      resource.find_all(select: [:code, :id])
    end
  end
end
