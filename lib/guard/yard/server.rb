require 'socket'

module Guard
  class Yard
    # Responsible for running, verifying and killing the YARD server.
    class Server
      attr_accessor :pid, :port, :host

      def initialize(options = {})
        @port = options[:port] || '8808'
        @host = options[:host] || 'localhost'
        @stdout = options[:stdout]
        @stderr = options[:stderr]
        @cli = options[:cli]
      end

      def spawn
        UI.info '[Guard::Yard] Starting YARD Documentation Server.'

        command = ["yard server -p #{port} -b #{host}"]
        command << @cli if @cli
        command << "2> #{@stderr}" if @stderr
        command << "1> #{@stdout}" if @stdout

        self.pid = Process.spawn(command.join(' '))
      end

      def kill
        UI.info '[Guard::Yard] Stopping YARD Documentation Server.'
        return true unless pid
        Gem.win_platform? ? windows_kill : posix_kill
      end

      def verify
        5.times do
          sleep 1
          begin
            TCPSocket.new(host, port.to_i).close
          rescue Errno::ECONNREFUSED
            next
          end
          UI.info '[Guard::Yard] Server successfully started.'
          return true
        end
        UI.error '[Guard::Yard] Error starting documentation server.'
        Notifier.notify(
          '[Guard::Yard] Server NOT started.',
          title: 'yard',
          image: :failed
        )
        false
      end

      private

      def windows_kill
        # /t includes child process
        # /f forces (required else we'll fail)
        if system("taskkill /f /t /pid #{pid}").nil?
          raise "Cannot kill server: Windows' taskkill command not found"
        end

        # Process was killed or it didn't exist (something else..?).
        true
      end

      def posix_kill
        begin
          Process.kill('QUIT', pid)
          Process.wait2(pid)
        # rubocop:disable Lint/HandleExceptions
        rescue Errno::ESRCH, Errno::ECHILD
          # Process is already dead.
        end
        true
      end
    end
  end
end
