require 'socket'

module Guard
  class Yard
    class Server
      attr_accessor :pid, :port

      def initialize(port)
        @port = port || '8808'
      end

      def spawn
        self.pid = fork
        raise 'Fork failed' if pid == -1

        unless pid
          Signal.trap('QUIT', 'IGNORE')
          Signal.trap('INT', 'IGNORE')
          Signal.trap('TSTP', 'IGNORE')

          exec("yard server -p #{port}")
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
