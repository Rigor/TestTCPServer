require_relative 'scripts/loader'

require 'socket'               # Get sockets from stdlib

loop {                         # Servers run forever
  begin  
    client = ServerSingleton.server.accept       # Wait for a client to connect
    Aborted.call(client, {})
  rescue Errno::ECONNRESET, Errno::EPIPE => e
    puts e.message
    puts e.backtrace
  ensure
    client.close
  end
}
