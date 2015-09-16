module Elmas
  class Item
    include Elmas::Resource

    def base_path
      "logistics/Items"
    end

    def mandatory_attributes
      [:code, :description]
    end

    def other_attributes # rubocop:disable Metrics/MethodLength
      [
        :class_01, :class_02, :class_03, :class_04, :class_05, :copy_remarks,
        :cost_price_currency, :cost_price_new, :cost_price_standard, :end_date,
        :extra_description, :free_bool_field_01, :free_bool_field_02, :free_bool_field_03,
        :free_bool_field_04, :free_bool_field_05, :free_date_field_01, :free_date_field_02,
        :free_date_field_03, :free_date_field_04, :free_date_field_05, :free_number_field_01,
        :free_number_field_02, :free_number_field_03, :free_number_field_04, :free_number_field_05,
        :free_number_field_06, :free_number_field_07, :free_number_field_08, :free_text_field_01,
        :free_text_field_02, :free_text_field_03, :free_text_field_04, :free_text_field_05,
        :free_text_field_06, :free_text_field_07, :free_text_field_08, :free_text_field_09,
        :free_text_field_10, :GL_costs, :GL_revenue, :GL_stock, :is_batch_item,
        :is_batch_number_item, :is_fraction_allowed_item, :is_make_item, :is_new_contract,
        :is_on_demand_item, :is_package_item, :is_registration_code_item, :is_purchase_item,
        :is_sales_item, :is_serial_item, :is_serial_number_item, :is_stock_item,
        :is_subcontracted_item, :is_time, :is_webshop_item, :item_group, :notes,
        :sales_vat_code, :search_code, :security_level, :start_date, :unit
      ]
    end
  end
end
