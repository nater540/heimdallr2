require 'rails/generators/base'
require 'securerandom'

module Heimdallr
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      def create_initializer
        template('heimdallr.rb', 'config/initializers/heimdallr.rb')
      end

      def copy_locale
        copy_file('../../../config/locales/en.yml', 'config/locales/heimdallr.en.yml')
      end
    end
  end
end
