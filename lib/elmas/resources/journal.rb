module Elmas
  class Journal
    include Elmas::Resource

    def base_path
      "financial/Journals"
    end

    def mandatory_attributes
      []
    end

    def other_attributes
      [
        :code, :description, :allow_variable_currency, :allow_variable_exchange_rate,
        :allow_VAT, :auto_save, :bank, :bank_account_ID, :bank_account_including_mask,
        :currency, :GL_account, :payment_in_transit_account, :type
      ]
    end
  end
end
