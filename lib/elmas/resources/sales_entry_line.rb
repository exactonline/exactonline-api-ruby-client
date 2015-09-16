module Elmas
  class SalesEntryLine < Elmas::BaseEntryLine
    # A sales entry line belongs to a sales entry
    include Elmas::Resource

    def base_path
      "salesentry/SalesEntryLines"
    end
  end
end
