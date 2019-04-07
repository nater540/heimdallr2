Heimdallr.configure do |config|

  # Optional default JWT claims
  config.claims do |claims|
    # iss - Issuer of the JWT.
    claims.issuer = 'your-domain-name-here'

    # iat - Time at which the JWT was issued; can be used to determine age of the JWT.
    claims.issued_at = -> { Time.current.utc.to_i }

    # nbf - Time before which the JWT must not be accepted for processing.
    claims.not_before = -> { Time.current.utc.to_i }

    # exp - Time after which the JWT expires.
    claims.expiration_time = -> { 30.minutes.from_now.utc }

    # jti - Unique identifier; can be used to prevent the JWT from being replayed (allows a token to be used only once).
    claims.jti = -> { SecureRandom.uuid }
  end

  # Additional JWT claims to include.
  # @see https://www.iana.org/assignments/jwt/jwt.xhtml#claims
  config.additional_claims = {}

  # Expiration leeway (in seconds) used to account for clock skew.
  config.expiration_leeway = 30

  # JWT algorithm to use.
  # Must be one of:
  #   `:HS256` - HMAC using SHA-256 hash algorithm.
  #   `:HS384` - HMAC using SHA-384 hash algorithm.
  #   `:HS512` - HMAC using SHA-512 hash algorithm.
  #   `:RS256` - RSA  using SHA-256 hash algorithm.
  #   `:RS384` - RSA  using SHA-384 hash algorithm.
  #   `:RS512` - RSA  using SHA-512 hash algorithm.
  config.algorithm = :HS512

  # Only used if `algorithm` is HMAC based & KMS is disabled.
  config.secret_key = '<%= SecureRandom.hex(64) %>'

  # Only used if `algorithm` is RSA based & KMS is disabled.
  config.secret_key_path = nil
end
