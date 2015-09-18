# TestTCPServer 
A webservice mocking HTTP requests.  TestTCPServer makes it easy to mock out specific requests at a lower level than most popular Ruby frameworks, including Rack (although inspiration is taken from Rack in some places).  This allows developers to mock out well-formed, malformed, or incomplete requests in order to test how systems handle these requests.

# Running
* `bundle install`
* `ruby server.rb [-p port number]` # By default the service listens to port 80

# Responses
Responses are handled by Responders.  When a request is received, the router will try to determine the correct responder to handle the request.  For example, a request to '/foo' would look for a Foo class to handle the request.  If no class exists, the server will respond with a 404 HTTP response.

There is no support for handling multiple clients at the same time.  This means that testing long running or non-terminating requests will be difficult.

# Responders
Any object that responds to :call and accepts two parameters can be a Responder. The two parameters are an open socket and a hash containing the environment that mostly conforms to the [Rack specification] (http://rack.rubyforge.org/doc/SPEC.html).  Additional elements are added to the hash; these non-conforming elements are prepended with an underscore, '_'.

Responders can write anything to the socket and may close the socket if desired.  If the responder does not close the socket, the socket will be closed automatically.

# Writing your own responders
Simply add a class in a file in the app directory with the responder.  Make sure to implement a class method :call on the class that accepts the socket and the environment.
