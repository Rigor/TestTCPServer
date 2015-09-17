class Aborted < Responder
  def call
    # Read the request
    client.puts('HTTP/1.1 200 Aborted')
    line = client.gets
    puts "#{Time.now.ctime} #{line}"
    client.puts()
    client.puts('Aborted')
  end
end
