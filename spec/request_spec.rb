require 'spec_helper'

describe Elmas::Request do
  let(:base_url) { "https://start.exactonline.nl" }
  let(:endpoint) { "api/v1" }
  let(:division) { "2332" }

  let(:url_with_endpoint_and_division) { "#{base_url}/#{endpoint}/#{division}"}
  let(:url_with_endpoint) { "#{base_url}/#{endpoint}"}
  let(:url_with_division) { "#{base_url}/#{division}"}

  before :each do
    Elmas.configure do |config|
      config.base_url = base_url
      config.endpoint = endpoint
      config.division = division
    end
  end

  it "does a get request" do
    stub_request(:get, "#{url_with_endpoint_and_division}/resource")
    expect(Elmas.get("resource")).to be_a(Elmas::Response)
  end

  it "does a get request without endpoint" do
    stub_request(:get, "#{url_with_division}/resource")
    expect(Elmas.get("resource", no_endpoint: true)).to be_a(Elmas::Response)
  end

  it "does a get request without division" do
    stub_request(:get, "#{url_with_endpoint}/resource")
    expect(Elmas.get("resource", no_division: true)).to be_a(Elmas::Response)
  end

  it "returns nill if id is not set and find is called" do
    resource = Elmas::Contact.new
    expect(resource.find).to eq(nil)
  end

  it "does a get request with params" do
    random_id = rand(999).to_s
    stub_request(:get, "#{url_with_endpoint_and_division}/salesinvoice/SalesInvoices(guid'#{random_id}')?")
    resource = Elmas::SalesInvoice.new(id: random_id)
    response = resource.find
  end

  it "does a post request" do
    params = { first_name: "Piet", last_name: "Mondriaan", account: 1 }
    stub_request(:post, "https://start.exactonline.nl/api/v1/2332/crm/Contacts").
            with(body: { "FirstName" => "Piet", "LastName" => "Mondriaan", "Account" => 1 }.to_json)
    resource = Elmas::Contact.new(params)
    response = resource.save
    expect(response).to be_a(Elmas::Response)
  end

  it "does a put request" do
    params = { id: 1, first_name: "Karel", last_name: "Appel", account: 1 }
    stub_request(:put, "https://start.exactonline.nl/api/v1/2332/crm/Contacts(guid'1')").
            with(body: { "FirstName" => "Karel", "LastName" => "Appel", "Account" => 1 }.to_json)
    resource = Elmas::Contact.new(params)
    response = resource.save
    expect(response).to be_a(Elmas::Response)
  end

  it "does a delete request" do
    random_id = rand(999).to_s
    params = { id: random_id }
    stub_request(:delete, "https://start.exactonline.nl/api/v1/2332/crm/Contacts(guid'#{random_id}')")
    resource = Elmas::Contact.new(params)
    response = resource.delete
    expect(response).to be_a(Elmas::Response)
  end

  it "normalizes belongs to relationships" do
    invoice_line = Elmas::SalesInvoiceLine.new(item: "1", invoice_ID: Elmas::SalesInvoice.new(journal: "1", id: "2"))
    expect(invoice_line.sanitize["InvoiceID"]).to eq("2")
  end

  it "normalizes has many relationships" do
    invoice_line1 = Elmas::SalesInvoiceLine.new(item: "1")
    invoice_line2 = Elmas::SalesInvoiceLine.new(item: "2")
    invoice = Elmas::SalesInvoice.new(journal: "1", ordered_by:"sd", sales_invoice_lines: [invoice_line1, invoice_line2])
    expect(invoice.sanitize["SalesInvoiceLines"]).to eq([{"Item"=>"1"}, {"Item"=>"2"}])
  end

  it "normalizes dates" do
    account = Elmas::Account.new(start_date: DateTime.new(2001,5,6,4,5,6))
    expect(account.sanitize["StartDate"]).to eq("datetime'2001-05-06T04:05'")
  end
end
