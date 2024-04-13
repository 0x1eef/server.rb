# frozen_string_literal: true

class Server
  require "rack"
  require_relative "server/puma"
  require_relative "server/gzip"
  require_relative "server/etag"
  require_relative "server/dir"

  ##
  # @param [String] path
  #  The path to a directory.
  #
  # @return [Rack::Builder]
  #  Returns a Rack app.
  def self.app(path)
    Rack::Builder.app do
      use Server::ETag
      run Server::Dir.new(path)
    end
  end
  private_class_method :app

  ##
  # @param [String] path
  #  The path to a directory.
  #
  # @param [Hash] options
  #  A hash of options.
  #
  # @return [Server]
  #  Returns an instance of {Server Server}.
  def self.for(path, options = {})
    host = options.delete(:host) || options.delete("host") || "127.0.0.1"
    port = options.delete(:port) || options.delete("port") || 3000
    unix = options.delete(:unix) || options.delete("unix") || nil
    new app(path), options.merge!(
      binds: [unix ? "unix://#{unix}" : "tcp://#{host}:#{port}"]
    )
  end

  ##
  # @param [Rack::Builder] app
  #  A rack app.
  #
  # @param [Hash] options
  #  A hash of options.
  #
  # @return [Server]
  #  Returns an instance of {Server Server}.
  def initialize(app, options = {})
    @app = app
    @options = default_options.merge!(options)
    @events = Puma::Events.new
    @server = Puma::Server.new(@app, @events, @options)
  end

  ##
  # Starts the web server.
  #
  # @param [Boolean] block
  #  When given as true, this method will block.
  #
  # @return [Thread]
  #  Returns a thread.
  def start(block: false)
    @server.binder.parse(@options[:binds])
    thr = @server.run
    block ? thr.join : thr
  end

  ##
  # Stops the web server.
  #
  # @return [void]
  def stop
    @server.stop
  end

  private

  def default_options
    {
      min_threads: 1,
      max_threads: 5,
      workers: 1
    }
  end
end
