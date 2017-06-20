module Elmas
  class BadRequestException < RuntimeError
    def initialize(response, parsed)
      @response = response
      @parsed = parsed
      super(message)
    end

    def message
      "code #{@response.status}: #{@parsed.error_message}"
    end
  end

  class UnauthorizedException < RuntimeError; end
  class InvalidAttributeException < RuntimeError
    def initialize(invalid_attributes)
      @invalid_attributes = invalid_attributes
      super(message)
    end

    def message
      "The following attributes are invalid: #{@invalid_attributes.inspect}"
    end
  end

  class InvalidResourceException < RuntimeError
    def initialize(name)
      @name = name
    end

    def message
      "Resource #{@name} we received is unkown and might need to
        be implemented, go to https://github.com/exactonline/exactonline-api-ruby-client
        and open an issue or pull request"
    end
  end
end
