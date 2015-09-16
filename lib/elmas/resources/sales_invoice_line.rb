module Elmas
  class SalesInvoiceLine
    # An sales_invoice_line should always have a reference to an item and to an sales_invoice.
    include Elmas::Resource

    def base_path
      "salesinvoice/SalesInvoiceLines"
    end

    def mandatory_attributes
      [:item, :invoice_ID]
    end

    def other_attributes
      [
        :discount, :quantity, :amount_FC, :description, :VAT_code, :cost_center,
        :cost_unit, :employeem, :end_time, :line_number, :net_price, :notes,
        :pricelist, :project, :quantity, :start_time, :subscription, :tax_schedule,
        :unit_code, :VAT_amount_DC, :VAT_amount_FC, :VAT_percentage
      ]
    end
  end
end
