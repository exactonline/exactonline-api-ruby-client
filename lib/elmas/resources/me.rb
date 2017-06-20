module Elmas
  class Me
    include Elmas::Resource

    def base_path
      "/Me"
    end

    def mandatory_attributes
      []
    end

    def other_attributes
      [
        :current_division, :division_customer, :division_customer_code, :current_division, :full_name, :user_ID, :user_name, :language_code,
        :legislation, :email, :title, :first_name, :last_name, :gender, :language, :phone
      ]
    end
  end
end
