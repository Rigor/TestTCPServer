require_relative 'scripts/loader'

require 'socket'               # Get sockets from stdlib

loop {                         # Servers run forever
  begin  
    client = ServerSingleton.server.accept       # Wait for a client to connect

    # TODO remove this
    sleep 1 # Wait to receive all of the message

    env = EnvironmentReader.new(client).to_h
    puts "#{Time.now.ctime} Received request #{env['REQUEST_METHOD']} #{env['_REQUEST_URL']}"
    puts "#{Time.now.ctime} #{env.inspect}"
    Router.new(client, env).route
  rescue Errno::ECONNRESET, Errno::EPIPE => e
    puts 'Connection reset or pipe closed'
    puts e.message
    puts e.backtrace
  rescue StandardError => e
    puts 'Error caught'
    puts e.message
    puts e.backtrace
  ensure
    client.close if client && !client.closed?
  end
}
