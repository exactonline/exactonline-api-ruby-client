# frozen_string_literal: true

require "elmas/version"
require "elmas/api"
require "elmas/config"
require "elmas/response"
require "elmas/client"
require "elmas/resource"
require "elmas/result_set"
require "elmas/sanitizer"
require "elmas/resources/aging_receivables_list"
require "elmas/resources/receivables_list"
require "elmas/resources/shared_sales_attributes"
require "elmas/resources/base_entry_line"
require "elmas/resources/bank_entry"
require "elmas/resources/bank_entry_line"
require "elmas/resources/bank_account"
require "elmas/resources/contact"
require "elmas/resources/sales_invoice"
require "elmas/resources/sales_invoice_line"
require "elmas/resources/printed_sales_invoice"
require "elmas/resources/layout"
require "elmas/resources/journal"
require "elmas/resources/sales_item_prices"
require "elmas/resources/item"
require "elmas/resources/item_group"
require "elmas/resources/account"
require "elmas/resources/gl_account"
require "elmas/resources/sales_entry"
require "elmas/resources/sales_entry_line"
require "elmas/resources/sales_order"
require "elmas/resources/sales_order_line"
require "elmas/resources/project"
require "elmas/resources/time_transaction"
require "elmas/resources/purchase_entry"
require "elmas/resources/purchase_entry_line"
require "elmas/resources/costunit"
require "elmas/resources/costcenter"
require "elmas/resources/transaction"
require "elmas/resources/transaction_line"
require "elmas/resources/document"
require "elmas/resources/document_attachment"
require "elmas/resources/mailbox"
require "elmas/resources/me"
require "elmas/resources/vat_code"
require "elmas/resources/general_journal_entry"
require "elmas/resources/general_journal_entry_line"
require "elmas/resources/payment_condition"
require "elmas/resources/division"

module Elmas
  extend Config

  def self.client(options = {})
    Elmas::Client.new(options)
  end

  # Delegate to Elmas::Client
  def self.method_missing(method, *args, &block)
    super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Elmas::Client
  def self.respond_to?(method, include_all = false)
    client.respond_to?(method, include_all) || super
  end

  def self.info(msg)
    logger.info(msg)
  end

  def self.error(msg)
    logger.error(msg)
  end
end
