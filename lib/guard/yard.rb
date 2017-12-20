require 'guard'
require 'guard/plugin'
require 'yard'

module Guard
  # Main guard-yard plugin class.
  class Yard < Plugin
    autoload :NoServer, 'guard/yard/no_server'
    autoload :Server, 'guard/yard/server'
    attr_accessor :server

    def initialize(options = {})
      super
      options[:server] = true unless options.key?(:server)
      @server = options[:server] ? Server.new(options) : NoServer.new
    end

    def start
      boot
    end

    def stop
      server.kill
    end

    def reload
      boot
    end

    def run_all
      UI.info '[Guard::Yard] Generating all documentation.'
      system('rm -rf .yardoc && yard doc')
      UI.info '[Guard::Yard] Documentation has been generated.'
      true
    end

    def run_on_changes(paths)
      UI.info "[Guard::Yard] Detected changes in #{paths.join(',')}."
      paths.each { |path| document([path]) }
      UI.info "[Guard::Yard] Updated documentation for #{paths.join(',')}."
    end

    private

    def check
      return true if File.exist?('.yardoc')
      UI.info '[Guard::Yard] Documentation missing.'
      run_all && true
    end

    def boot
      check && server.kill && server.spawn && server.verify
    end

    def document(files)
      ::YARD::Registry.load!
      ::YARD::Registry.load(files, true)
      ::YARD::Registry.load_all
      yardoc = ::YARD::CLI::Yardoc.new
      yardoc.parse_arguments
      options = yardoc.options
      objects = ::YARD::Registry.all(:root, :module, :class).reject do |object|
        (!options[:serializer] || options[:serializer].exists?(object)) \
          && object.files.none? { |f, _line| files.include?(f) }
      end
      ::YARD::Templates::Engine.generate(objects, options)
      save_registry
    end

    def save_registry
      ::YARD::Registry.save(true)
    end
  end
end
