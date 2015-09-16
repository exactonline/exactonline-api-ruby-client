require "elmas/version"
require "elmas/api"
require "elmas/config"
require "elmas/response"
require "elmas/client"
require "elmas/log"
require "elmas/resource"
require "elmas/sanitizer"
require "elmas/resources/base_entry_line"
require "elmas/resources/bank_entry"
require "elmas/resources/bank_entry_line"
require "elmas/resources/contact"
require "elmas/resources/sales_invoice"
require "elmas/resources/journal"
require "elmas/resources/item"
require "elmas/resources/item_group"
require "elmas/resources/sales_invoice_line"
require "elmas/resources/account"
require "elmas/resources/gl_account"
require "elmas/resources/sales_entry"
require "elmas/resources/sales_entry_line"
require "elmas/resources/sales_order"
require "elmas/resources/sales_order_line"
require "elmas/resources/purchase_entry"
require "elmas/resources/purchase_entry_line"
require "elmas/resources/costunit"
require "elmas/resources/costcenter"
require "elmas/resources/transaction"
require "elmas/resources/transaction_line"
require "elmas/resources/document"
require "elmas/resources/document_attachment"
require "elmas/resources/mailbox"

module Elmas
  extend Config
  extend Log

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
end
