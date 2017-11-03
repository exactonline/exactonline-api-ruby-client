[![Build Status](https://travis-ci.org/exactonline/exactonline-api-ruby-client.svg?branch=master)](https://travis-ci.org/exactonline/exactonline-api-ruby-client)
[![Code Climate](https://codeclimate.com/github/exactonline/exactonline-api-ruby-client/badges/gpa.svg)](https://codeclimate.com/github/exactonline/exactonline-api-ruby-client)
[![Gem Version](https://badge.fury.io/rb/elmas.svg)](http://badge.fury.io/rb/elmas)
[![Join the chat at https://gitter.im/exactonline/exactonline-api-ruby-client](https://badges.gitter.im/exactonline/exactonline-api-ruby-client.svg)](https://gitter.im/exactonline/exactonline-api-ruby-client?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# Elmas

Elmas means diamond, but in this case it's an API wrapper for [Exact Online](https://developers.exactonline.com/). This gem was created by [@Marthyn](https://github.com/marthyn), [Hoppinger](http://www.hoppinger.com) and a few people:

### Contributers

* [Commuun](https://github.com/commuun)
* [dunyakirkali](https://github.com/dunyakirkali)
* [Korstiaan](https://github.com/korstiaan)
* [confiks](https://github.com/confiks)
* [Menno-de-brie](https://github.com/Menno-de-brie)
* [Dahie](https://github.com/Dahie)
* [mipmip](https://github.com/mipmip)
* [Bramjetten](https://github.com/Bramjetten)
* [LaurensN](https://github.com/LaurensN)

Thanks for helping! If you want to contribute read through this readme how to!

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

Then configure Elmas like this (take these values from your app that you setup at apps.exactonline.com)

```ruby
Elmas.configure do |config|
  config.client_id = ENV['CLIENT_ID']
  config.client_secret = ENV['CLIENT_SECRET']
  config.redirect_uri = ENV['REDIRECT_URI']
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

### Logger

The default logger is STDOUT. A custom logger can be be configured.
```ruby
  dir = File.dirname("./tmp/errors.log")
  FileUtils.mkdir_p(dir) unless File.directory?(dir)

  Elmas.configure do |config|
    config.logger = ::Logger.new("./tmp/errors.log", "daily")
  end
```

## Accessing the API

We can retrieve data from the API using the following syntax.

The query will return an `Elmas::ResultSet` which contains up to 60 records and
a method to retrieve the next page of results. Unfortunately the ExactOnline API
does not allow us to retrieve a specific page or define how many records we want
to retrieve at a time.

```ruby
# Query the API and return an Elmas::ResultSet
accounts = Elmas::Account.new.find_all

# Return an array of accounts
accounts.records
```

If the query results in more than 60 records the next set can be retrieved using
the `next_page` method.

```ruby
# Return an Elmas::ResultSet containing the next page's records
accounts.next_page
```

### Filter and sort results

Filtering result sets can be done by adding attributes to the initializer and then
using `find_by`. Filters accept a single value or an array of values.

```ruby
# Find the account with code 123
accounts = Elmas::Account.new(code: '123').find_by(filters: [:code])

# Find the accounts with code 123 and 345
accounts = Elmas::Account.new(code: ['123', '345']).find_by(filters: [:code])
```

You can also match on values "greater than" or "less than" by specifying `gt` or `lt`:

```ruby
# Find all AgingReceivables with an amount greater than 0 in the third age range
Elmas::AgingReceivablesList.new(age_group3_amount: { gt: 0 }).find_by(filters: [:age_group3_amount])
```

Results can be sorted in the same way

```ruby
# Return all accounts sorted by first name
accounts = Elmas::Account.new.find_all(order_by: :first_name)
```

Filters and sorting can also be combined

```ruby
# Return accounts with code 123 and 345 sorted by first name
accounts = Elmas::Account.new(code: ['123', '345']).find_by(filters: [:code], order_by: :first_name)
```

To find an individual record by its ID the `find` method can be used

```ruby
# Return the account with guid
account = Elmas::Account.new(id: '9e3a078e-55dc-40f4-a490-1875400a3e10').find
```

For more information on this way of selecting data look here http://www.odata.org/

### Creating new records

Use the initializer method followed by 'save' to create a new record:

```ruby
# Create a new contact
contact = Elmas::Contact.new(first_name: "Karel", last_name: "Appel", account: "8d87c8c5-f1c6-495c-b6af-d5ba396873b5"  )
contact.save
```

### Projects and Time Tracking

Project Types:

- :type=>2, :type_description=>"Fixed price"
- :type=>3, :type_description=>"Time and Material"
- :type=>4, :type_description=>"Non billable"
- :type=>5, :type_description=>"Prepaid"

To create a new project

```ruby
project = Elmas::Project.new(code: "PROJ902343", description: "Great project", account: "8d87c8c5-f1c6-495c-b6af-d5ba396873b5", type: 2 )
project.save
```

To submit a new time transaction

```ruby
hours = Elmas::TimeTransaction.new(account: "8d87c8c5-f1c6-495c-b6af-d5ba396873b5", item: "eb73942a-53c0-4ee9-bbb2-6d985814a1b1", quantity: 3.0, notes: "")
hours.save
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

