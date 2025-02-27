require_relative "../../lib/gemcutter/middleware/hostess"
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :mem_cache_store,
                         { compress: true, compression_min_size: 524_288 }
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.action_mailer.delivery_method = :letter_opener_web
  config.action_mailer.perform_deliveries = true

  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.perform_caching = false

  config.action_mailer.default_url_options = { host: Gemcutter::HOST,
                                               port: ENV.fetch("PORT", "3000"),
                                               protocol: Gemcutter::PROTOCOL }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  config.middleware.use Gemcutter::Middleware::Hostess
  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # By default, keep rails logs looking like standard rails logs
  # (multiple lines per request, no timestamp/thread/process/level/logger name, etc)
  enable_semantic_log_format = ENV['ENABLE_SEMANTIC_LOG_FORMAT'].present?
  config.rails_semantic_logger.semantic   = false
  config.rails_semantic_logger.started    = !enable_semantic_log_format
  config.rails_semantic_logger.processing = !enable_semantic_log_format
  config.rails_semantic_logger.rendered   = !enable_semantic_log_format
  unless enable_semantic_log_format
    require 'rails_development_log_formatter'
    SemanticLogger.add_appender(io: $stdout, formatter: RailsDevelopmentLogFormatter.new)
    config.rails_semantic_logger.format = RailsDevelopmentLogFormatter.new
  end

  # Rubygems.org checks for the presence of an env variable called PROFILE that
  # switches several settings to a more "production-like" value for profiling
  # and benchmarking the application locally. All changes you make to the app
  # will require restart.
  if ENV['PROFILE']
    config.cache_classes = true
    config.eager_load = true

    config.log_level = :info
    config.rails_semantic_logger.format     = :json
    config.rails_semantic_logger.semantic   = true
    config.rails_semantic_logger.started    = false
    config.rails_semantic_logger.processing = false
    config.rails_semantic_logger.rendered   = false

    config.public_file_server.enabled = true
    config.public_file_server.headers = {
      'Cache-Control' => 'max-age=315360000, public',
      'Expires' => 'Thu, 31 Dec 2037 23:55:55 GMT'
    }
    config.assets.js_compressor = :terser
    config.assets.css_compressor = :sass
    config.assets.compile = false
    config.assets.digest = true
    config.assets.debug = false

    config.active_record.migration_error = false
    config.active_record.verbose_query_logs = false
    config.action_view.cache_template_loading = true
  end

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
end
