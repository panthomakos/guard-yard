require 'socket'

module Guard
  class Yard
    class Server
      attr_accessor :options, :pid, :port

      def initialize(options, port)
        @options = options || ''
        @port = port || '8808'
      end

      def spawn
        self.pid = fork
        raise 'Fork failed' if pid == -1

        unless pid
          Signal.trap('QUIT', 'IGNORE')
          Signal.trap('INT', 'IGNORE')
          Signal.trap('TSTP', 'IGNORE')

          exec("yard server #{options} -p #{port}")
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
          UI.info "YARD Documentation Server successfully started"
          return true
        end
        UI.error "Could not start YARD Documentation Server"
        Notifier.notify "YARD Documentation Server NOT started",
          :title => 'yard', :image => failed
        false
      end
    end
  end
end
