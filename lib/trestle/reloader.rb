module Trestle
  class Reloader
    delegate :execute, :updated?, to: :updater

    def execute_if_updated
      if defined?(@updater)
        updater.execute_if_updated
      else
        updater.execute
      end
    end

    def updater
      @updater ||= ActiveSupport::FileUpdateChecker.new([], compile_load_paths) do
        begin
          clear

          load_paths.each do |load_path|
            matcher = /\A#{Regexp.escape(load_path.to_s)}\/(.*)\.rb\Z/
            Dir.glob("#{load_path}/**/*.rb").sort.each do |file|
              require_dependency file.sub(matcher, '\1')
            end
          end
        ensure
          # Ensure that routes are reloaded even if an exception occurs
          # when reading an admin definition file.
          Rails.application.reload_routes!
        end
      end
    end

    def clear
      Trestle.admins = {}
    end

    def load_paths
      Trestle.config.load_paths.map { |path| path.respond_to?(:call) ? path.call : path }.flatten.map(&:to_s)
    end

  private
    def compile_load_paths
      Hash[*load_paths.map { |path| [path, "rb"] }.flatten]
    end
  end
end
