class Aborted < Responder
  def call
    # Read the request
    client.puts('HTTP/1.1 0 Aborted')
  end
end
