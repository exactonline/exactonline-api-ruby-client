require "faraday"
require "active_resource/threadsafe_attributes"
require "logger"

module Elmas
  module Config
    include ThreadsafeAttributes
    # An array of valid keys in the options hash
    VALID_OPTIONS_KEYS = [
      :access_token,
      :adapter,
      :client_id,
      :client_secret,
      :connection_options,
      :redirect_uri,
      :response_format,
      :user_agent,
      :endpoint,
      :division,
      :base_url,
      :refresh_token,
      :logger
    ].freeze

    # By default, don't set a user access token
    DEFAULT_ACCESS_TOKEN = "".freeze

    DEFAULT_REFRESH_TOKEN = "".freeze

    # The adapter that will be used to connect if none is set
    #
    # @note The default faraday adapter is Net::HTTP.
    DEFAULT_ADAPTER = Faraday.default_adapter

    # By default, client id should be set in .env
    DEFAULT_CLIENT_ID = "".freeze

    # By default, client secret should be set in .env
    DEFAULT_CLIENT_SECRET = "".freeze

    # By default, don't set any connection options
    DEFAULT_CONNECTION_OPTIONS = {}.freeze

    DEFAULT_BASE_URL = "https://start.exactonline.nl".freeze

    # The endpoint that will be used to connect if none is set
    DEFAULT_ENDPOINT = "api/v1".freeze

    # the division code you want to connect with
    DEFAULT_DIVISION = "".freeze

    # The response format appended to the path and sent in the 'Accept' header if none is set
    #
    DEFAULT_FORMAT = :json

    DEFAULT_REDIRECT_URI = "https://www.getpostman.com/oauth2/callback".freeze

    # By default, don't set user agent
    DEFAULT_USER_AGENT = nil

    # An array of valid request/response formats
    VALID_FORMATS = [:json].freeze

    DEFAULT_LOGGER = ::Logger.new(STDOUT)

    # @private
    threadsafe_attribute(*VALID_OPTIONS_KEYS)

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.access_token       = DEFAULT_ACCESS_TOKEN
      self.adapter            = DEFAULT_ADAPTER
      self.client_id          = DEFAULT_CLIENT_ID
      self.client_secret      = DEFAULT_CLIENT_SECRET
      self.connection_options = DEFAULT_CONNECTION_OPTIONS
      self.redirect_uri       = DEFAULT_REDIRECT_URI
      self.endpoint           = DEFAULT_ENDPOINT
      self.division           = DEFAULT_DIVISION
      self.base_url           = DEFAULT_BASE_URL
      self.response_format    = DEFAULT_FORMAT
      self.user_agent         = DEFAULT_USER_AGENT
      self.refresh_token      = DEFAULT_REFRESH_TOKEN
      self.logger             = DEFAULT_LOGGER
    end
  end
end
