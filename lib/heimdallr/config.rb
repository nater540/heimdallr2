require 'dry-configurable'

module Heimdallr
  extend Dry::Configurable

  # Optional default JWT claims
  setting :claims do
    # iss - Issuer of the JWT.
    setting :iss

    # iat - Time at which the JWT was issued; can be used to determine age of the JWT.
    setting :iat, -> { Time.current.utc.to_i }

    # nbf - Time before which the JWT must not be accepted for processing.
    setting :nbf, -> { Time.current.utc.to_i }

    # exp - Time after which the JWT expires.
    setting :exp, -> { 30.minutes.from_now.utc.to_i }

    # jti - Unique identifier; can be used to prevent the JWT from being replayed (allows a token to be used only once).
    setting :jti, -> { SecureRandom.uuid }
  end

  # Additional JWT claims to include.
  # @see https://www.iana.org/assignments/jwt/jwt.xhtml#claims
  setting :additional_claims, OpenStruct.new

  # Default scopes to use if none are present on new tokens.
  setting :default_scopes, []

  # Expiration leeway (in seconds) used to account for clock skew.
  setting :expiration_leeway, 30

  # JWT algorithm to use.
  # Must be one of:
  #   `:HS256` - HMAC using SHA-256 hash algorithm.
  #   `:HS384` - HMAC using SHA-384 hash algorithm.
  #   `:HS512` - HMAC using SHA-512 hash algorithm.
  #   `:RS256` - RSA  using SHA-256 hash algorithm.
  #   `:RS384` - RSA  using SHA-384 hash algorithm.
  #   `:RS512` - RSA  using SHA-512 hash algorithm.
  setting :algorithm, :HS512

  # Only used if `algorithm` is HMAC based & KMS is disabled.
  setting :secret_key

  # Only used if `algorithm` is RSA based & KMS is disabled.
  setting :secret_key_path

  setting :kms do
    # The KMS provider to use, eg: `Heimdallr::KMS::VaultClient`
    setting :provider

    # Prefix string to use when reading/writing keys.
    setting :prefix, 'heimdallr'

    # Vault specific settings.
    setting :vault do
      # The address of the Vault server.
      setting :address, ENV['VAULT_ADDR']

      # The token to authenticate with Vault.
      setting :token, ENV['VAULT_TOKEN']

      # Custom SSL PEM.
      setting :ssl_pem_file, ENV['VAULT_SSL_CERT']
      
      # As an alternative to a pem file you can provide the raw PEM string (Based64 encoded)
      setting :ssl_pem_contents, ENV['VAULT_SSL_PEM_CONTENTS_BASE64']

      # Use SSL verification.
      setting :ssl_verify, ENV.fetch('VAULT_SSL_VERIFY', false)

      # Timeout the connection after a certain amount of time (seconds).
      setting :timeout, ENV.fetch('VAULT_TIMEOUT', 30)
    end
  end
end
