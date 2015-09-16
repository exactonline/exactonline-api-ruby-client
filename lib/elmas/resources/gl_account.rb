module Elmas
  class GLAccount
    include Elmas::Resource

    def base_path
      "financial/GLAccounts"
    end

    def mandatory_attributes
      [:code, :description]
    end

    def other_attributes
      [
        :assimilated_VAT_box, :balance_side, :balance_type, :belcotax_type, :compress,
        :cost_center, :cost_unit, :exclude_VAT_listing, :expense_non_deductible_percentage,
        :is_blocked, :matching, :private_GL_account, :private_percentage, :reporting_code,
        :revalue_currency, :searc_code, :type, :use_cost_center, :use_cost_unit,
        :VAT_code, :VAT_GL_account_type, :VAT_non_deductible_GL_account,
        :VAT_non_deductible_percentage, :VAT_system, :year_end_cost_GL_account,
        :year_end_reflection_GL_account
      ]
    end
  end
end
