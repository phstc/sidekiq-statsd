require 'socket'

module Guard
  class Yard
    class Server
      attr_accessor :pid, :port

      def initialize(options = {})
        @port = options[:port] || '8808'
        @stdout = options[:stdout]
        @stderr = options[:stderr]
        @cli = options[:cli]
      end

      def spawn
        self.pid = fork
        raise 'Fork failed' if pid == -1

        unless pid
          Signal.trap('QUIT', 'IGNORE')
          Signal.trap('INT', 'IGNORE')
          Signal.trap('TSTP', 'IGNORE')

          command = ["yard server -p #{port}"]
          command << @cli if @cli
          command << "2> #{@stderr}" if @stderr
          command << "1> #{@stdout}" if @stdout
          exec command.join(' ')
        end
        pid
      end

      def kill
        Process.kill('KILL', pid) unless pid.nil?
        true
      end

      def verify
        5.times do
          sleep 1
          begin
            TCPSocket.new('localhost', port.to_i).close
          rescue Errno::ECONNREFUSED
            next
          end
          UI.info "[Guard::Yard] Server successfully started."
          return true
        end
        UI.error "[Guard::Yard] Error starting documentation server."
        Notifier.notify "[Guard::Yard] Server NOT started.",
          :title => 'yard', :image => :failed
        false
      end
    end
  end
end
