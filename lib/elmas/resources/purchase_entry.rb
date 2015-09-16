module Elmas
  class PurchaseEntry
    include Elmas::Resource

    def base_path
      "purchaseentry/PurchaseEntries"
    end

    def mandatory_attributes
      [:journal, :purchase_entry_lines, :supplier]
    end

    def other_attributes
      [
        :currency, :batch_number, :description, :document, :due_date, :entry_date,
        :entry_number, :external_link_reference, :invoice_number, :rate, :reporting_period,
        :reporting_year, :reversal, :VAT_amount_FC, :your_ref
      ]
    end
  end
end
