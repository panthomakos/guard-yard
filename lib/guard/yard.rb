require 'guard'
require 'guard/guard'

module Guard
  class Yard < Guard
    autoload :Server, 'guard/yard/server'
    attr_accessor :server, :options

    def initialize(watchers=[], options={})
      super
      @server = Server.new(options[:server], options[:port])
      @options = options
      @options[:doc] ||= ''
    end

    def start
      UI.info "Starting YARD Documentation Server"
      server.kill and server.spawn and server.verify
    end

    def stop
      server.kill
    end

    def reload
      UI.info "Reloading YARD Documentation Server"
      server.kill and server.spawn and server.verify
    end

    def run_all
      UI.info "Creating all YARD Documentation"
      system "yard doc #{options[:doc]} --no-cache"
    end

    def run_on_change(paths)
      paths.each{ |path| system "yard doc '#{path}' #{options[:doc]} -c" }
    end
  end
end
