# Amazon::Iap2

[![Codeship Status for blinkist/amazon-iap2](https://www.codeship.io/projects/e6c868f0-2f7e-0132-4314-02ba1e9dff5b/status)](https://www.codeship.io/projects/39519)
[![Dependency Status](https://www.versioneye.com/user/projects/5645bcefb5b03d002200084e/badge.svg?style=flat)](https://www.versioneye.com/user/projects/5645bcefb5b03d002200084e)
[![Gem Version](https://badge.fury.io/rb/amazon-iap2.svg)](http://badge.fury.io/rb/amazon-iap2)

This gem is a simple implementation of the Amazon receipt verfication service outlined
[here](https://developer.amazon.com/sdk/in-app-purchasing/documentation/rvs.html) with migrations from [here](https://developer.amazon.com/public/apis/earn/in-app-purchasing/docs-v2/verifying-receipts-in-iap-2.0)


## Installation

Add this line to your application's Gemfile:

    gem 'amazon-iap2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install amazon-iap2

## Usage

**NOTE:** Amazon does not deploy a sandbox environment for testing purposes.  Rather,
they give you access to a deployable WAR file.  You can use this WAR file to easily deploy your
own sandbox environment on Heroku.  See [here](https://devcenter.heroku.com/articles/war-deployment#command-line)
for more details.

Initialize a client, passing in the developer secret and (optionally) the host.  If a host is not
passed, it will use Amazon's production endpoint.

```ruby
client = Amazon::Iap::Client.new 'my_developer_secret', 'http://iap-staging.domain.com' # staging server
client = Amazon::Iap::Client.new 'my_developer_secret' # production server
```


## Returned Values

An instance of Amazon::Iap2::Result is returned from both methods, the attributes being the underscored versions
of the hash keys returned in the JSON object.  For convenience, we also add `purchase_time` and `cancel_time` attributes
which are `Time` representations of the milliseconds returned in `cancel_date` and `cancel_date` respectively.  E.g.,

```ruby
result = client.verify 'some-user-id', 'some-receipt-id'

result.class.name        # "Amazon::Iap2::Result"
result.product_type      # "SUBSCRIPTION"
result.product_id        # "some-sku"
result.parent_product_id # nil
result.purchase_date     # 1378751554943
result.purchase_time     # 2013-09-09 14:32:34 -0400 
result.cancel_date       # nil
result.cancel_time       # nil
result.quantity          # 1
result.test_transaction  # false
result.beta_product      # false
result.term              # term length of product type is Subscription e.g"1 YEAR" 
result.term_sku          # sku of the product subscription 
result.renewal_date      # renewal date of subscription product (in ms)
```

## Exception Handling

Any non-200 status code will raise an exception.  For convenience in internal controls, each status code raises
a distinct exception.  Take a look at the [Amazon::Iap2::Result class](lib/amazon/iap2/result.rb) for specifics.

Example exception handling:

```ruby
begin
  result = client.verify 'some-user-id', 'some-receipt-id'
rescue Amazon::Iap2::Exceptions::InternalError => e
  # enqueue to try again later
end
```

For convenience, all exceptions inherit from `Amazon::Iap2::Exceptions::Exception` so you can rescue from
any exception (or as a default):

```ruby
begin
  result = client.verify 'some-user-id', 'receipt-id'
rescue Amazon::Iap2::Exceptions::InternalError => e
  # enqueue to try again later
rescue Amazon::Iap2::Exceptions::Exception => e
  # log the exception
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b some-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin some-new-feature`)
5. Create new Pull Request
