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
        UI.info "[Guard::Yard] Starting YARD Documentation Server."

        command = ["yard server -p #{port}"]
        command << @cli if @cli
        command << "2> #{@stderr}" if @stderr
        command << "1> #{@stdout}" if @stdout

        self.pid = Process.spawn(command.join(' '))
      end

      def kill
        UI.info "[Guard::Yard] Stopping YARD Documentation Server."
        begin
          if pid
            Process.kill('QUIT', pid)
            Process.wait2(pid)
          end
        rescue Errno::ESRCH, Errno::ECHILD
          # Process is already dead.
        end
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
