require 'active_support/inflector'

class Router
  def initialize(socket, env)
    @socket = socket
    @env = env
  end

  def route
    responder_class.call(socket, env)
  end

  protected

  attr_reader :socket, :env

  def request_url
    env['_REQUEST_URL']
  end

  def request_path
    request_url.split('?').first
  end

  def responder_class
    request_path.camelize.constantize
  rescue
    if Object.const_defined?('Default')
      Default
    else
      default_lambda
    end
  end

  def default_lambda
    -> (client, _env) do
      client.puts('HTTP/1.1 404 Not Found')
      client.puts
      client.puts('Not Found')
    end
  end
end
