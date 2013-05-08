require 'guard'
require 'guard/guard'
require 'yard'

module Guard
  class Yard < Guard
    autoload :Server, 'guard/yard/server'
    attr_accessor :server

    def initialize(watchers=[], options={})
      super
      @server = Server.new(options)
    end

    def start
      UI.info "[Guard::Yard] Starting YARD Documentation Server."
      boot
    end

    def stop
      server.kill
    end

    def reload
      UI.info "[Guard::Yard] Reloading YARD Documentation Server."
      boot
    end

    def run_all
      UI.info "[Guard::Yard] Generating all documentation."
      system('rm -rf .yardoc && yard doc')
      UI.info "[Guard::Yard] Documentation has been generated."
      true
    end

    def run_on_changes(paths)
      UI.info "[Guard::Yard] Detected changes in #{paths.join(',')}."
      paths.each{ |path| document([path]) }
      UI.info "[Guard::Yard] Updated documentation for #{paths.join(',')}."
    end

    private

    def check
      return true if File.exists?('.yardoc')
      UI.info "[Guard::Yard] Documentation missing."
      run_all and true
    end

    def boot
      check and server.kill and server.spawn and server.verify
    end

    def document files
      ::YARD::Registry.load!
      ::YARD::Registry.load(files, true)
      ::YARD::Registry.load_all
      yardoc = ::YARD::CLI::Yardoc.new
      yardoc.parse_arguments
      options = yardoc.options
      objects = ::YARD::Registry.all(:root, :module, :class).reject do |object|
        (!options[:serializer] || options[:serializer].exists?(object)) \
          && !object.files.any?{|f,line| files.include?(f)}
      end
      ::YARD::Templates::Engine.generate(objects, options)
      save_registry
    end

    def save_registry
      ::YARD::Registry.save(true)
    end
  end
end
