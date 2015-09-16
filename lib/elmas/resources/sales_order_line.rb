module Elmas
  class SalesOrderLine
    include Elmas::Resource

    def base_path
      "salesorder/SalesOrderLines"
    end

    def mandatory_attributes
      [:item, :order_ID]
    end

    def other_attributes
      [
        :amount_FC, :cost_center, :cost_unit, :delivery_date, :description,
        :discount, :item_version, :net_price, :notes, :order_number, :pricelist,
        :project, :quantity, :tax_schedule, :unit_code, :unit_price, :use_drop_shipment,
        :VAT_amount, :VAT_code, :VAT_percentage
      ]
    end
  end
end
