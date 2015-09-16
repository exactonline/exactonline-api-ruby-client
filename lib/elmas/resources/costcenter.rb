module Elmas
  class Costcenter
    include Elmas::Resource

    def base_path
      "hrm/Costcenters"
    end

    def mandatory_attributes
      [:code, :description]
    end

    def other_attributes
      [:active]
    end
  end
end
