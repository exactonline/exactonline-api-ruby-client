# frozen_string_literal: true

module Elmas
  class SalesInvoice
    # An sales_invoice usually has multiple sales_invoice lines
    # It should also have a journal id and a contact id who ordered it
    include Elmas::Resource
    include Elmas::SharedSalesAttributes

    def base_path
      "salesinvoice/SalesInvoices"
    end

    def mandatory_attributes
      [:ordered_by]
    end

    def other_attributes
      SHARED_SALES_ATTRIBUTES.inject(
        %i[sales_invoice_lines due_date sales_person starter_sales_invoice_status type journal],
        :<<
      )
    end
  end
end
