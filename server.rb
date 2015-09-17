require_relative 'lib/loader'

require 'socket'               # Get sockets from stdlib

port_index = (ARGV.find_index{|arg| arg == '-p'} || -1) + 1
port = (ARGV[port_index] || 80).to_i
puts "Creating server on port #{port}"
server = TCPServer.open(port)

loop {                         # Servers run forever
  begin  
    client = server.accept       # Wait for a client to connect
    Aborted.call(client, {})
  rescue Errno::ECONNRESET, Errno::EPIPE => e
    puts e.message
    puts e.backtrace
  ensure
    client.close
  end
}
