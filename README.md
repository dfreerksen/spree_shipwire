# SpreeShipwire

Shipwire. For Spree. Without Wombat.

This gem only sends certain pieces of data to Shipwire. Webhooks are not supported in this gem. To use webhooks, use `[spree_shipwire_webhooks](https://github.com/dfreerksen/spree_shipwire_webhooks/) 


## Installation

Add this line to your Spree application's Gemfile:

```
gem 'spree_shipwire', github: 'dfreerksen/spree_shipwire'
```

> Note: This is currently under development. It is not a good idea to use this in a production environment.

> Note: The master branch is not guaranteed to be in a fully functioning state. It is unwise to use this branch in a production system.

Run the bundle command:

```
bundle install
```

After installing, run the generator:

```
rails g shipwire:install
```


## Testing

Generate a dummy application

```
bundle exec rake test_app
```

Running tests

```
bundle exec rspec spec
```


## Contributing

1. Fork it ( https://github.com/dfreerksen/spree_shipwire/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
