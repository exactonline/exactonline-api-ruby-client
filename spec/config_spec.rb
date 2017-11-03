require "spec_helper"

describe Elmas do
  it "has a config" do
    expect(Elmas.config[:base_url]).to eq("https://start.exactonline.nl")
  end

  let(:new_url) { "www.google.com/api" }

  it "can set a config var" do
    Elmas.configure do |config|
      config.base_url = new_url
    end

    expect(Elmas.config[:base_url]).to eq(new_url)
  end

  it "should be thread safe" do
    Elmas.configure { |config| config.base_url = 'foo' }

    Thread.new do
      Elmas.configure { |config| config.base_url = 'bar' }
    end.join

    expect(Elmas.config[:base_url]).to eq 'foo'
  end

  it "should default to main thread values" do
    Elmas.configure { |config| config.base_url = 'foo' }

    Thread.new do
      expect(Elmas.config[:base_url]).to eq 'foo'
    end.join
  end

  it "should configure a default logger when included" do
    Elmas.logger.must_equal Elmas::CONFIG::DEFAULT_LOGGER
  end

  it "should configure a given logger when specified" do
    Elmas.logger.must_equal Elmas::CONFIG::DEFAULT_LOGGER
    obj = ::Object.new
    Elmas.configure { |config| config.logger = obj }
    Foobar.logger.must_equal obj
  end

  it "should reset logger configuration to default" do
    Elmas.logger.must_equal Elmas::CONFIG::DEFAULT_LOGGER
    obj = ::Object.new
    Elmas.configure { |config| config.logger = obj }
    Foobar.logger.must_equal obj
    Elmas.reset
    Elmas.logger.must_equal Elmas::CONFIG::DEFAULT_LOGGER
  end
end
