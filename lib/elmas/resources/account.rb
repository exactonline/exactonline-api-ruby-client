module Elmas
  class Account
    # An account needs a name
    include Elmas::Resource

    def base_path
      "crm/Accounts"
    end

    def mandatory_attributes
      [:name]
    end

    # https://start.exactonline.nl/docs/HlpRestAPIResourcesDetails.aspx?id=9
    def other_attributes # rubocop:disable Metrics/MethodLength
      [
        :accountant, :account_manager, :activity_sector,
        :activity_sub_sector, :address_line1, :address_line2,
        :address_line3, :blocked, :business_type, :can_drop_ship,
        :chamber_of_commerce, :city, :code, :code_at_supplier,
        :company_size, :consolidation_scenario, :controlled_date,
        :cost_paid, :country, :credit_line_purchase, :credit_line_sales,
        :discount_purchase, :discount_sales, :email, :end_date, :fax,
        :intra_stat_area, :intra_stat_delivery_term, :intra_stat_system,
        :intra_stat_transaction_a, :intra_stat_transaction_b,
        :intra_stat_transport_method, :invoice_acount, :invoice_attachment_type,
        :invoicing_method, :is_accountant, :is_agency, :is_competitor, :is_mailing,
        :is_pilot, :is_reseller, :is_sales, :is_supplier, :language, :latitude,
        :lead_source, :logo, :logo_file_name, :longitude, :main_contact,
        :payment_condition_purchase, :payment_condition_sales, :phone,
        :phone_extension, :postcode, :price_list, :purchase_currency,
        :purchase_lead_days, :purchase_VAT_code, :recipient_of_commissions,
        :remarks, :reseller, :sales_currency, :sales_tax_schedule, :sales_VAT_code,
        :search_code, :security_level, :seperate_inv_per_project, :seperate_inv_per_subscription,
        :shipping_lead_days, :shipping_method, :start_date, :state, :status,
        :VAT_liability, :VAT_number, :website
      ]
    end
  end
end
