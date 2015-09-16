module Elmas
  class Contact
    # A contact needs a First and Last name and a reference to an account
    include Elmas::Resource

    def base_path
      "crm/Contacts"
    end

    def mandatory_attributes
      [:first_name, :last_name, :account]
    end

    def other_attributes
      [
        :account_name, :birt_date, :birth_name, :birth_name_prefix, :birth_place,
        :business_email, :business_fax, :business_mobile, :business_phone, :business_phone_extention,
        :email, :end_date, :first_name, :gender, :HID, :initials, :is_mailing_excluded,
        :job_title_description, :language, :marketing_notes, :middle_name,
        :mobile, :nationality, :notes, :person, :phone, :picture, :picture_name,
        :social_security_number, :start_date, :title
      ]
    end
  end
end
