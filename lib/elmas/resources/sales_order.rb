module Elmas
  class SalesOrder
    include Elmas::Resource

    def base_path
      "salesorder/SalesOrders"
    end

    def mandatory_attributes
      [:sales_order_lines, :ordered_by]
    end

    def other_attributes
      [
        :currency, :deliver_to, :deliver_to_contact_person, :delivery_date,
        :delivery_status, :description, :document, :invoice_status, :invoice_to,
        :invoice_to_contact_person, :order_date, :ordered_by_contact_person,
        :order_number, :payment_condition, :payment_reference, :remarks,
        :sales_person, :shipping_method, :status, :tax_schedule, :warehouse_ID,
        :your_ref
      ]
    end
  end
end
