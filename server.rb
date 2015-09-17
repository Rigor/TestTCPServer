require 'byebug'
require 'socket'               # Get sockets from stdlib
port_index = (ARGV.find_index{|arg| arg == '-p'} || -1) + 1
port = (ARGV[port_index] || 80).to_i
puts "Creating server on port #{port}"
server = TCPServer.open(port)

loop {                         # Servers run forever
  begin  
    client = server.accept       # Wait for a client to connect

    # Read the request
    client.puts('HTTP/1.1 200 Aborted')
    line = client.gets 
    puts "#{Time.now.ctime} #{line}"
    client.close_read 
    # Set the response
    puts "Set response codes"
    client.puts()
    puts "Added empty line"
    client.puts('Aborted')
    puts "Wrote aborted"
    client.close                 # Disconnect from the client
  rescue Errno::ECONNRESET, Errno::EPIPE => e
    puts e.message
    puts e.backtrace
    client.close
  end
}
