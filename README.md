[![Build Status](https://travis-ci.org/exactonline/exactonline-api-ruby-client.svg?branch=master)](https://travis-ci.org/exactonline/exactonline-api-ruby-client)
[![Code Climate](https://codeclimate.com/github/exactonline/exactonline-api-ruby-client/badges/gpa.svg)](https://codeclimate.com/github/exactonline/exactonline-api-ruby-client)
[![Gem Version](https://badge.fury.io/rb/elmas.svg)](http://badge.fury.io/rb/elmas)

# Elmas

Elmas means diamond, but in this case it's an API wrapper for [Exact Online](https://developers.exactonline.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'elmas'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elmas

## Authorization and Setup

You have to have an Exact Online account and an app setup to connect with.

You have to set a few variables to make a connection possible. I'd suggest using environment variables set with [dotenv](https://github.com/bkeepers/dotenv) for that.

Then configure Elmas like this

```ruby
Elmas.configure do |config|
  config.client_id = ENV['CLIENT_ID']
  config.client_secret = ENV['CLIENT_SECRET']
end
```

If you only use the api within your app without exposing it to users you can chose
to automatically login with your credentials. So this is for example when you have a
rake task that shoots in invoices.
Do not use this when you let other users login. Build your own OAUTH flow and then set the access token
before the api request.
```ruby
Elmas.configure do |config|
  config.access_token = Elmas.authorize(ENV['EXACT_USER_NAME'], ENV['EXACT_PASSWORD']).access_token
end
```
Now you're authorized you can set your current division
```ruby
Elmas.configure do |config|
  config.division = Elmas.authorize_division
end
```

So combining all of this results in
```ruby
Elmas.configure do |config|
  config.client_id = ENV['CLIENT_ID']
  config.client_secret = ENV['CLIENT_SECRET']
end
Elmas.configure do |config|
  config.access_token = Elmas.authorize(ENV['EXACT_USER_NAME'], ENV['EXACT_PASSWORD']).access_token
end
Elmas.configure do |config|
  config.division = Elmas.authorize_division
end
```

You should make sure that when you do a request you're authorized. So build in something like the
following code into your application, that checks wether you're authorized and otherwise authorizes
again.
```ruby
#The client will now be authorized for 10 minutes,
# if there are requests the time will be reset,
# otherwise authorization should be called again.
unless Elmas.authorized?
  Elmas.configure do |config|
    config.access_token = Elmas.authorize(ENV['EXACT_USER_NAME'], ENV['EXACT_PASSWORD']).access_token
  end
end
```

## GET, PUT, POST requests

For any of the following requests (GET, PUT, POST), to get the results do the following. (the exact API always returns a List)
```ruby
contact = Elmas::Contact.new(id: "23445")
response = contact.find
puts response.first
# Prints something like this
# [<Elmas::Contact:0x007fb0a55782f0 @attributes={:__metadata=>{"uri"=>"https://start.exactonline.nl/api/v1/797636/crm/Contacts(guid'23445')", "type"=>"Exact.Web.Api.Models.Contact"}, :id=>"23445", :person=>"88380fa4-97bc-4ddf-90e3-b0e7befb112c"}>

contact = Elmas::Contact.new.find_all
response = contact.find_all
puts response.results
# Prints something like this
# [<Elmas::Contact:0x007fb0a55782f0 @attributes={:__metadata=>{"uri"=>"https://start.exactonline.nl/api/v1/797636/crm/Contacts(guid'23445')", "type"=>"Exact.Web.Api.Models.Contact"}, :id=>"23445", :person=>"88380fa4-97bc-4ddf-90e3-b0e7befb112c"}>, <Elmas::Contact:0x007fb0a55782f0 @attributes={:__metadata=>{"uri"=>"https://start.exactonline.nl/api/v1/797636/crm/Contacts(guid'23445')", "type"=>"Exact.Web.Api.Models.Contact"}, :id=>"23445", :person=>"88380fa4-97bc-4ddf-90e3-b0e7befb112c"}>]
```

To find a contact

```ruby
contact = Elmas::Contact.new(id: "23445")
contact.find
# path = /crm/Contacts(guid'23445')
```

To find a contact with specific filters
```ruby
contact = Elmas::Contact.new(first_name: "Karel", id: "23")
contact.find_by(filters: [:first_name])
# path = /crm/Contacts?$filter=first_name eq 'Karel'
```

To find contacts with an order and a filter
```ruby
contact = Elmas::Contact.new(first_name: "Karel")
contact.find_by(filters: [:first_name], order_by: :first_name)
# path = /crm/Contacts?$order_by=first_name&$filter=first_name eq 'Karel'
```

To find contacts with an order, a filter and selecting relationships
```ruby
contact = Elmas::Contact.new(first_name: "Karel")
contact.find_by(filters: [:first_name], order_by: :first_name, select: [:last_name])
# path = /crm/Contacts?$select=last_name&$order_by=first_name&$filter=first_name eq 'Karel'
```

So with find_by you can combine Filters, Select and OrderBy. For more information on this way of selecting data look here http://www.odata.org/
There's also a method find_all, which does a get without filters. You can however set the select and order by params.

To find all contacts
```ruby
contact = Elmas::Contact.new
contact.find_all
# path = /crm/Contacts
```

To find all contacts and order by first_name
```ruby
contact = Elmas::Contact.new
contact.find_all(order_by: :first_name)
# path = /crm/Contacts?$order_by=first_name
```

To find all contacts and select invoices and items
```ruby
contact = Elmas::Contact.new
contact.find_all(select: [:last_name, :first_name])
# path = /crm/Contacts?$select=last_name,first_name
```

To create a new contact

```ruby
contact = Elmas::Contact.new(first_name: "Karel", last_name: "Appel"  )
contact.save
```

### SalesInvoice flow
SalesInvoices have a relationship with SalesInvoiceLines. A SalesInvoice has many
SalesInvoiceLines and a SalesInvoiceLine belongs to a SalesInvoice. To create a
valid SalesInvoice you need to embed the SalesInvoiceLines

```ruby
sales_invoice = Elmas::SalesInvoice.new(journal: "id of your journal", ordered_by: "id of customer")
```
Now it still needs SalesInvoiceLines
```ruby
sales_invoice_lines = []
sales_invoice_lines << Elmas::SalesInvoiceLine.new(item: "id of item being sold") # do this for each item you want in the invoice.
sales_invoice.sales_invoice_lines = sales_invoice_lines
```
Now you can save the SalesInvoice and it will be parsed to the following
```ruby
sales_invoice.save
# Sanitized object: {"Journal"=>"id of your journal", "OrderedBy"=>"id of customer", "SalesInvoiceLines"=>[{"Item"=>"id of item being sold"}]}
```

If you have a SalesInvoice with an id(so saved before already), you can also create invoice lines without embedding
```ruby
sales_invoice = Elmas::SalesInvoice.new({id: "1"}).first
sales_invoice_line = Elmas::SalesInvoiceLine.new(invoice_ID: sales_invoice, item: "42")
sales_invoice.save
# Sanitized object: {"Item"=>"42", "InvoiceID"=>"1"}
```

For many resources there are mandatory attributes, you can see that in the classes
for every resource. For example for Contact: https://github.com/exactonline/exactonline-api-ruby-client/blob/master/lib/elmas/resources/contact.rb

###Divisions and Endpoints

Usually in the exact wrapper you need a division number, this one will be set on authorization checks (with `/Current/Me` endpoint). Sometimes you need to do a request without the division number, or even without the standard `/api/v1` endpoint. Like so:

```ruby
response = Elmas.get('/api/oauth2/token', no_endpoint: true, no_division: true)
response = Elmas.get('/Current/Me', no_division: true)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/elmas/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Testing

We use Rspec for normal unit testing. We aim for coverage above 90%. Also the current suite should succeed when you commit something.
We use Rubocop for style checking, this should also succeed before you commit anything.

We're also experimenting with Mutation testing, which alters your code to test if your specs fail when there's faulty code. This is important when you
alter a vital part of the code, make sure the mutation percentage is higher than 80%. To run a part of the code with mutant run the follwing
`mutant --include lib/elmas --require elmas --use rspec Elmas::ClassYoureWorkingOn`

To test the vital classes run this
`mutant --include lib --require elmas --use rspec Elmas::Response Elmas::Client Elmas::Utils Elmas::Resource Elmas::Request Elmas::Parser Elmas::Config`
This will take a few minutes

When you're editing code it's advised you run guard, which watches file changes and automatically runs Rspec and Rubocop.

## Hoppinger

This gem was created by [Hoppinger](http://www.hoppinger.com)

[![forthebadge](http://forthebadge.com/images/badges/built-with-ruby.svg)](http://www.hoppinger.com)
