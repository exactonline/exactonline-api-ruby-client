module Elmas
  module Utils
    def self.demodulize(class_name_in_module)
      class_name_in_module.to_s.sub(/^.*::/, "")
    end

    def self.pluralize(word)
      word.to_s.sub(/([^s])$/, '\1s')
    end

    def self.modulize(class_name)
      "Elmas::#{class_name}"
    end

    def self.collection_path(class_name)
      (Utils.pluralize Utils.demodulize class_name).downcase
    end

    def self.camelize(word, uppercase_first_letter = true)
      if uppercase_first_letter
        word.to_s.gsub(%r{/\/(.?)/}) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
      else
        word[0] + Utils.camelize(word)[1..-1]
      end
    end

    def self.normalize_hash_key(key)
      if key.is_a? String
        key = key.gsub(/::/, "/")
        key = key.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        key = key.gsub(/([a-z\d])([A-Z])/, '\1_\2')
        key = key.tr("-", "_")
        key = key.downcase
        return key.to_sym
      end
      key
    end

    def self.normalize_hash(hash)
      Hash[hash.map { |k, v| [Utils.normalize_hash_key(k), v] }] if hash
    end

    def self.parse_key(key)
      "VATCode" if key.downcase == "vat_code"
      Utils.camelize(key)
    end
  end
end
