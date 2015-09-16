module Elmas
  class BankEntry
    include Elmas::Resource

    def base_path
      "financialtransaction/BankEntries"
    end

    def mandatory_attributes
      [:journal_code, :bank_entry_lines]
    end

    def other_attributes
      [
        :currency, :bank_statement_document, :closing_balance_FC, :entry_number,
        :financial_period, :financial_year, :openening_balance_FC
      ]
    end
  end
end
