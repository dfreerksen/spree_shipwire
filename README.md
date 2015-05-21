# SpreeShipwire

Shipwire. For Spree. Without Wombat.


## Installation

Add this line to your Spree application's Gemfile:

```ruby
gem 'spree_shipwire', github: 'dfreerksen/spree_shipwire'
```

> Note: This is currently under development. It is not a good idea to use this in a production environment.

> Note: The master branch is not guaranteed to be in a fully functioning state. It is unwise to use this branch in a production system.

Run the bundle command:

```shell
bundle install
```

After installing, run the generator:

```shell
bundle exec rails g spree_shipwire:install
```


## Testing

Generate a dummy application

```shell
bundle exec rake test_app
```

Running tests

```shell
bundle exec rake spec
```

or

```shell
bundle exec rspec spec
```

#### Failing Tests

Tests are using a throwaway Shipwire (beta) account that is only meant for testing. Tests assume that Shipwire is clean. Meaning there are currently no secret tokens and webhooks enabled. If any are present, the tests will fail.


## Contributing

1. Fork it ( https://github.com/dfreerksen/spree_shipwire/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
