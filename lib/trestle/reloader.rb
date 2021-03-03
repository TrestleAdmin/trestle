module Trestle
  class Reloader
    delegate :execute, :execute_if_updated, :updated?, to: :updater

    def initialize(files, dirs = {})
      @files, @dirs = files, dirs
    end

    def updater
      @updater ||= ActiveSupport::FileUpdateChecker.new(@files, @dirs) do
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
      Trestle.registry.reset!
    end

    def load_paths
      Trestle.config.load_paths.map { |path| path.respond_to?(:call) ? path.call : path }.flatten.map(&:to_s)
    end

    def install(app)
      reloader = self

      app.reloaders << reloader

      if app.respond_to?(:reloader)
        # Rails >= 5.0
        app.reloader.to_run do
          reloader.execute_if_updated
          true # Rails <= 5.1
        end
      else
        # Rails 4.2
        ActionDispatch::Reloader.to_prepare do
          reloader.execute_if_updated
        end
      end

      reloader.execute
    end
  end
end
