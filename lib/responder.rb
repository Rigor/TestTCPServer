class Responder
  def self.call(client, env)
    new(client, env).call
  end

  protected

  attr_reader :client, :env

  def initialize(client, env)
    @client = client
    @env = env
  end
end
