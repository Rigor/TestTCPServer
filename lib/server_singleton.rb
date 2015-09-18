class ServerSingleton
  def self.server
    @server ||= TCPServer.open(port)
  end

  def self.port
    @port ||= (ARGV[port_index] || 80).to_i
  end

  protected

  def self.port_index
    @port_index ||= (ARGV.find_index{|arg| arg == '-p'} || -1) + 1
  end

end
