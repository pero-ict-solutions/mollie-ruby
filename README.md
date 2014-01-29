# Mollie API client for Ruby

Accepting [iDEAL](https://www.mollie.nl/betaaldiensten/ideal/), [Mister Cash](https://www.mollie.nl/betaaldiensten/mistercash/), [Creditcard](https://www.mollie.nl/betaaldiensten/creditcard/), and [paysafecard](https://www.mollie.nl/betaaldiensten/paysafecard/) online payments without fixed monthly costs or any punishing registration procedures. Just use the Mollie API to receive payments directly on your website.

## Requirements
To use the Mollie API client, the following things are required:

+ Get yourself a free [Mollie account](https://www.mollie.nl/aanmelden). No sign up costs.
+ Create a new [Website profile](https://www.mollie.nl/beheer/account/profielen/) to generate API keys (live and test mode) and setup your webhook.
+ Now you're ready to use the Mollie API client in test mode.
+ In order to accept payments in live mode, payment methods must be activated in your account. Follow [a few of steps](https://www.mollie.nl/beheer/diensten), and let us handle the rest.

## Installation

Add this line to your application's Gemfile:

    gem 'mollie', github: 'pero-ict-solutions/mollie'

And then execute:

    $ bundle

## Usage

the most basic way of getting paid is to prepare the payment on the Mollie server and then redirect the user to the provided `paymentUrl`. Make sure you store the payment `id` for further references. When the user makes a payment, Mollie will call the provided `redirect_url` webhook with the `id` as the POST parameter.

### Prepare payment

```ruby
amount = 99.99
description = "My Cool product"
redirect_url = "http://mystore.com/orders/update"
payment = Mollie::Payment.new(api_key)
response = payment.prepare(amount, description, redirect_url)
payment_id = response["id"]
redirect_to response["links"]["paymentUrl"]
```

### Get status

```ruby
response = Mollie::Payment.status(payment_id)
response["status"]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
