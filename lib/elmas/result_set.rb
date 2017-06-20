module Elmas
  class ResultSet
    attr_reader :records

    def initialize(parsed_response)
      @parsed_response = parsed_response

      @records = if @parsed_response.results
                   @parsed_response.results.map do |attributes|
                     resource_class.send(:new, attributes)
                   end
                 else
                   [resource_class.send(:new, @parsed_response.result)]
                 end
    end

    def next_page
      return unless next_page_url
      next_page = Elmas.get(next_page_url, use_raw_path: true)
      return unless next_page

      response = Elmas::Response.new(next_page)
      response.results
    end

    def first
      records.first
    end

    protected

    def next_page_url
      @parsed_response.next_page_url
    end

    def type
      if @parsed_response.metadata
        c_type = @parsed_response.metadata["type"]
      elsif @parsed_response.results.any?
        c_type = @parsed_response.results.first["__metadata"]["type"]
      end
      c_type.split(".").last
    end

    def resource_class
      @resource_class ||= begin
        constant_name = Utils.modulize(type)
        Object.const_get(constant_name)
      rescue NameError
        raise InvalidResourceException.new(type), ""
      end
    end
  end
end
