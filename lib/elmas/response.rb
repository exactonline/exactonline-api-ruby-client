require File.expand_path("../parser", __FILE__)
require File.expand_path("../utils", __FILE__)

module Elmas
  class Response
    attr_accessor :status_code, :body, :response

    def initialize(response)
      @response = response
      log_error if fail?
    end

    def success?
      @response.success? || SUCCESS_CODES.include?(status)
    end

    def body
      @response.body
    end

    def parsed
      Parser.new(body)
    end

    def results
      results = []
      if parsed.results
        parsed.results.each do |attributes|
          klass = resolve_class
          results << klass.send(:new, attributes)
        end
      end
      results
    end

    def result
      klass = resolve_class
      klass.send(:new, parsed.result)
    end

    def first
      results ? results.first : result
    end

    def type
      if parsed.metadata
        c_type = parsed.metadata["type"]
      elsif parsed.results.any?
        c_type = parsed.results.first["__metadata"]["type"]
      end
      c_type.split(".").last
    end

    def status
      @response.status
    end

    def fail?
      ERROR_CODES.include? status
    end

    def error_message
      parsed.error_message
    end

    def log_error
      message = "An error occured, the response had status #{status}. The content of the error was: #{error_message}"
      Elmas.error(message)
    end

    def unauthorized?
      UNAUTHORIZED_CODES.include? status
    end

    SUCCESS_CODES = [
      201, 202, 203, 204, 301, 302, 303, 304
    ]

    ERROR_CODES = [
      400, 401, 402, 403, 404, 500, 501, 502, 503
    ]

    UNAUTHORIZED_CODES = [
      400, 401, 402, 403
    ]

    private

    def resolve_class
      constant_name = Utils.modulize(type)
      return Object.const_get(constant_name)
    rescue NameError
      Elmas.info("Unknown resource encountered, proceed as usual but further resource details might have to be implemented")
      return Class.new { include Elmas::Resource }
    end
  end
end
