require 'vault'

module Heimdallr
  module KMS
    class VaultClient

      def connection
        @connection ||= Vault::Client.new(**Heimdallr.config.kms.vault)
      end
    end
  end
end
