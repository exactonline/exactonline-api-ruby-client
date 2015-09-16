require "spec_helper"

# TODO: (dunyakirkali) write better specs
describe Elmas::OAuth do
  describe "#" do
    it "authorize" do
      client_id = "24509072-f819-40ff-b888-4cd545985392"
      Elmas.configure do |config|
        config.client_id = client_id
      end
      stream = File.read("spec/fixtures/exact_login.html")
      login_params = { client_id: client_id, redirect_uri: "https://www.getpostman.com/oauth2/callback", response_type: "code" }
      stub_request(:get, "https://start.exactonline.nl/api/oauth2/auth/?client_id=24509072-f819-40ff-b888-4cd545985392&redirect_uri=redirect_uri&response_type=code").to_return(body: stream, headers: { content_type: "text/html" })
      stub_request(:get, "https://start.exactonline.nl/api/oauth2/auth/?client_id=24509072-f819-40ff-b888-4cd545985392&redirect_uri=https://www.getpostman.com/oauth2/callback&response_type=code").to_return(body: stream, headers: { content_type: "text/html" })
      stub_request(:post, "https://start.exactonline.nl/api/oauth2/auth/?client_id=24509072-f819-40ff-b888-4cd545985392&redirect_uri=https://www.getpostman.com/oauth2/callback&response_type=code")
      stub_request(:post, "https://start.exactonline.nl/api/oauth2/token")
      response = Elmas.authorize("ExactUsernae", "ExactPassword")
      expect(response.status).to eq(200)
    end
  end
end
