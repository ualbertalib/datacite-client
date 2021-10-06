class Config
  attr_accessor :host, :username, :password, :prefix

  def initialize
    @host = ENV['DATACITE_HOST'] || 'api.test.datacite.org'
    @username = ENV['DATACITE_USERNAME']
    @password = ENV['DATACITE_PASSWORD']
    @prefix = ENV['DATACITE_PREFIX']
  end
end
