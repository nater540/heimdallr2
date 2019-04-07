require 'active_support/core_ext/numeric/time'
require 'active_support/dependencies'
require 'ostruct'
require 'base64'
require 'json'

require 'heimdallr/version'
require 'heimdallr/config'
require 'heimdallr/models'

module Heimdallr
  class Error < StandardError; end

  LIBRARY_PATH = File.join(File.dirname(__FILE__), 'heimdallr')

  autoload :Token, File.join(LIBRARY_PATH, 'token')

  module Models
    MODELS_PATH = File.join(LIBRARY_PATH, 'models')
    autoload :User, File.join(MODELS_PATH, 'user')
  end

  module KMS
    KMS_PATH = File.join(LIBRARY_PATH, 'kms')
    autoload :VaultClient, File.join(KMS_PATH, 'vault_client')
  end
end
