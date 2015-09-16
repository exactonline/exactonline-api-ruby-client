module Elmas
  class SalesInvoice
    # An sales_invoice usually has multiple sales_invoice lines
    # It should also have a journal id and a contact id who ordered it
    include Elmas::Resource

    def base_path
      "salesinvoice/SalesInvoices"
    end

    def mandatory_attributes
      [:journal, :ordered_by]
    end

    def other_attributes
      [
        :sales_invoice_lines, :type, :currency, :description, :document, :due_date,
        :invoice_date, :invoice_to, :invoice_to_contact_person, :order_date,
        :ordered_by_contact_person, :order_number, :payment_condition, :payment_reference,
        :remarks, :sales_person, :starter_sales_invoice_status, :tax_schedule,
        :type, :your_ref
      ]
    end
  end
end
