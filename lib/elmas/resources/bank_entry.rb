# frozen_string_literal: true

module Elmas
  class BankEntry
    include Elmas::Resource

    def base_path
      "financialtransaction/BankEntries"
    end

    def mandatory_attributes
      %i[journal_code bank_entry_lines]
    end

    def other_attributes
      %i[
        currency bank_statement_document closing_balance_FC entry_number
        financial_period financial_year opening_balance_FC created modified
      ]
    end
  end
end
