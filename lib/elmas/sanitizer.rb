module Elmas
  module Resource
    module Sanitizer
      # Parse the attributes for to post to the API
      def sanitize
        to_submit = {}
        @attributes.each do |key, value|
          next if key == :id || !valid_attribute?(key)
          key = Utils.parse_key(key)
          submit_value = sanitize_relationship(value)
          to_submit[key] = submit_value
        end
        to_submit
      end

      def sanitize_relationship(value)
        if value.is_a?(Elmas::Resource)
          return value.id # Turn relation into ID
        elsif value.is_a?(Array)
          return sanitize_has_many(value)
        elsif value.is_a?(DateTime)
          return sanitize_date_time(value)
        else
          return value
        end
      end

      def sanitize_date_time(value)
        value.strftime("datetime'%Y-%m-%dT%H:%M'")
      end

      def sanitize_has_many(value)
        submit_value = []
        value.each do |e|
          submit_value << e.sanitize
        end
        submit_value
      end
    end
  end
end
