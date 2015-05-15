RSpec.configure do |config|
  config.before :each do
    SpreeShipwire.configure do |c|
      c.username = "david.freerksen@groundctrl.com"
      c.password = "gOg6maBr6E"
      c.timeout = 10
    end
  end
end
