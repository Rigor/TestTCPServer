class Aborted < Responder
  def call
    # Read the request
    client.puts('HTTP/1.1 200 Aborted')
    client.puts()
    client.puts('Aborted')
  end
end
