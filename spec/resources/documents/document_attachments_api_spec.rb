require 'spec_helper'

describe Elmas::DocumentAttachment do

  before do
    stub_request(:get, "https://start.exactonline.nl/api/v1//Current/Me").
       with(:headers => {'Accept'=>'application/response_format', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access_token', 'Content-Type'=>'application/response_format', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
  end

  it "can initialize" do
    document = Elmas::DocumentAttachment.new
    expect(document).to be_a(Elmas::DocumentAttachment)
  end

  it "returns value for getters" do
    document = Elmas::DocumentAttachment.new({ "FileName" => "345" })
    expect(document.file_name).to eq "345"
  end

  it "crashes and burns when getting an unset attribute" do
    document = Elmas::DocumentAttachment.new({ name: "Piet" })
    expect(document.try(:file_name)).to eq nil
  end

  it "is valid with certain attributes" do
    document = Elmas::DocumentAttachment.new({ attachment: "dsad", document: "2332", file_name: "a_file.txt" })
    expect(document.valid?).to eq(true)
  end

  it "is valid without certain attributes" do
    document = Elmas::DocumentAttachment.new
    expect(document.valid?).to eq(false)
  end

  let(:resource) { resource = Elmas::DocumentAttachment.new(id: "12abcdef-1234-1234-1234-123456abcdef", file_name: "1223") }

  context "Applying filters" do
    it "should apply ID filter for find" do
      expect(Elmas).to receive(:get).with("documents/DocumentAttachments(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      expect(Elmas).to receive(:get).with("documents/DocumentAttachments?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      expect(Elmas).to receive(:get).with("documents/DocumentAttachments?$filter=FileName+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:file_name, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      expect(Elmas).to receive(:get).with("documents/DocumentAttachments?$orderby=FileName&$filter=FileName+eq+'1223'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:file_name, :id], order_by: :file_name)
    end

    it "should only apply the order_by" do
      expect(Elmas).to receive(:get).with("documents/DocumentAttachments?$orderby=FileName")
      resource.find_all(order_by: :file_name)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      expect(Elmas).to receive(:get).with("documents/DocumentAttachments?$select=FileName")
      resource.find_all(select: [:file_name])
    end

    it "should apply one select with find_by" do
      expect(Elmas).to receive(:get).with("documents/DocumentAttachments?$select=FileName")
      resource.find_by(select: [:file_name])
    end

    it "should apply one select" do
      expect(Elmas).to receive(:get).with("documents/DocumentAttachments?$select=FileName,Id")
      resource.find_all(select: [:file_name, :id])
    end
  end
end
