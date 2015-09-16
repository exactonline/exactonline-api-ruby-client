module Elmas
  class ItemGroup
    include Elmas::Resource

    def valid_actions
      [:get]
    end

    def base_path
      "logistics/ItemGroups"
    end

    def other_attributes
      [:code]
    end

    def mandatory_attributes
      []
    end
  end
end
