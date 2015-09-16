module Elmas
  class Mailbox
    include Elmas::Resource

    def base_path
      "mailbox/Mailboxes"
    end

    def other_attributes
      [
        :account, :description, :for_division, :publish,
        :type, :valid_from, :valid_to
      ]
    end

    def mandatory_attributes
      [:mailbox]
    end
  end
end
