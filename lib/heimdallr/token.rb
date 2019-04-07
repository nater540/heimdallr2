require 'jwt'

module Heimdallr
  module Token

    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        attr_writer :algorithm
        def algorithm
          @algorithm ||= Heimdallr.config.algorithm
        end
      end
    end

    PERMITTED_ALGORITHMS = %i[HS256 HS384 HS512 RS256 RS384 RS512]

    def claims
      @claims ||= OpenStruct.new(
        Heimdallr.config.claims.to_h.merge(Heimdallr.config.additional_claims.to_h)
      )
    end

    def resolve_claims
      claims.to_h.transform_values do |val|
        next val unless val.respond_to?(:call)
        val.call
      end
    end

    def scopes
      @scopes ||= Heimdallr.config.default_scopes
    end

    # Set the scopes for this token.
    #
    # @param [String, Array, Auth::Scopes] value The scopes to set.
    def scopes=(value)
      value = value.split if value.is_a?(String)
      value = value.uniq  if value.is_a?(Array)
      self.scopes = value
    end

    # Checks whether or not this token has specific scopes.
    #
    # @param [Array] values The scopes to check for.
    def has_scopes?(*values)
      values.all? { |scope| scopes.include?(scope) }
    end

    # Encodes this token into a JWT string.
    #
    # @return [String]
    def encode
      raise RuntimeError, "#{algorithm} is not a valid algorithm." unless PERMITTED_ALGORITHMS.include?(algorithm)

      # Prepare the token payload
      payload = resolve_claims
      payload[:scopes] = scopes
      payload.delete_if { |_, value| value.nil? }

      secret = if %i[HS256 HS384 HS512].include?(algorithm)
          Heimdallr.config.secret_key
        elsif %i[RS256 RS384 RS512].include?(algorithm)
          OpenSSL::PKey::RSA.new(File.read(Heimdallr.config.secret_key_path))
        else
          raise StandardError, 'You are likely to be eaten by a grue.'
        end

      ::JWT.encode(payload, secret, algorithm.to_s)
    end

    protected

    # Verifies that the token loaded from the database is valid and ready to be used.
    def verify_token_claims
      leeway = Heimdallr.config.expiration_leeway

    end

    module ClassMethods
      def from_request(request)

      end
    end
  end
end
