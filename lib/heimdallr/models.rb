module Heimdallr
  module Models

    def self.included(base)
      base.class_eval do
        class_attribute :heimdallr_modules
        self.heimdallr_modules ||= []
        extend ClassMethods
      end
    end

    module ClassMethods

      def heimdallr_feature(*modules)
        modules = modules.map(&:to_sym).uniq
        modules.each do |mod_name|
          klass = Heimdallr::Models.const_get(mod_name.to_s.classify)

          # If the mod has ClassModules declared, then extend them as well
          if klass.const_defined?('ClassMethods')
            extend klass.const_get('ClassMethods')
          end

          include klass
        end

        self.heimdallr_modules |= modules
      end
    end
  end
end
