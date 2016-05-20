require 'spec_helper'

describe Elmas::Project do

  before do
    stub_request(:get, "https://start.exactonline.nl/api/v1//Current/Me").
       with(:headers => {'Accept'=>'application/response_format', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access_token', 'Content-Type'=>'application/response_format', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
  end

  it "can initialize" do
    project = Elmas::Project.new
    expect(project).to be_a(Elmas::Project)
  end

  it "accepts attribute setter" do
    project = Elmas::Project.new
    project.code = "P001"
    expect(project.code).to eq "P001"
  end

  it "returns value for getters" do
    project = Elmas::Project.new({ "description" => "Urenbundel 30 uur" })
    expect(project.description).to eq "Urenbundel 30 uur"
  end

  it "crashes and burns when getting an unset attribute" do
    project = Elmas::Project.new({ code: "P001" })
    expect(project.try(:code)).to eq nil
  end

  context "Applying filters" do
    it "should apply ID filter for find" do
      resource = Elmas::Project.new(id: "12abcdef-1234-1234-1234-123456abcdef")
      expect(Elmas).to receive(:get).with("project/Projects(guid'12abcdef-1234-1234-1234-123456abcdef')?")
      resource.find
    end

    it "should apply no filters for find_all" do
      resource = Elmas::Project.new(id: "12abcdef-1234-1234-1234-123456abcdef", code: "P001")
      expect(Elmas).to receive(:get).with("project/Projects?")
      resource.find_all
    end

    it "should apply given filters for find_by" do
      resource = Elmas::Project.new(id: "12abcdef-1234-1234-1234-123456abcdef", code: "P001")
      expect(Elmas).to receive(:get).with("project/Projects?$filter=Code+eq+'P001'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:code, :id])
    end
  end

  context "Applying order" do
    it "should apply the order_by and filters" do
      resource = Elmas::Project.new(id: "12abcdef-1234-1234-1234-123456abcdef", code: "P001")
      expect(Elmas).to receive(:get).with("project/Projects?$orderby=Code&$filter=Code+eq+'P001'&$filter=ID+eq+guid'12abcdef-1234-1234-1234-123456abcdef'")
      resource.find_by(filters: [:code, :id], order_by: :code)
    end

    it "should only apply the order_by" do
      resource = Elmas::Project.new(id: "12abcdef-1234-1234-1234-123456abcdef", code: "P001")
      expect(Elmas).to receive(:get).with("project/Projects?$orderby=Code")
      resource.find_all(order_by: :code)
    end
  end

  context "Applying select" do
    it "should apply one select" do
      resource = Elmas::Project.new(id: "12abcdef-1234-1234-1234-123456abcdef", code: "P001")
      expect(Elmas).to receive(:get).with("project/Projects?$select=Code")
      resource.find_all(select: [:code])
    end

    it "should apply one select with find_by" do
      resource = Elmas::Project.new(id: "12abcdef-1234-1234-1234-123456abcdef", code: "P001")
      expect(Elmas).to receive(:get).with("project/Projects?$select=Code")
      resource.find_by(select: [:code])
    end

    it "should apply one select" do
      resource = Elmas::Project.new(id: "12abcdef-1234-1234-1234-123456abcdef", code: "P001")
      expect(Elmas).to receive(:get).with("project/Projects?$select=Code,Description")
      resource.find_all(select: [:code, :description])
    end
  end
end
