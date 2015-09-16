module Elmas
  class BaseEntryLine
    def mandatory_attributes
      [:amount_FC, :GL_account, :entry_ID]
    end

    def other_attributes
      [
        :serial_number, :asset, :cost_center, :cost_unit, :description, :notes,
        :project, :quantity, :serial_number, :subscription, :tracking_number,
        :VAT_amount_FC, :VAT_base_amount_DC, :VAT_base_amount_FC, :VAT_code,
        :VAT_percentage
      ]
    end
  end
end
