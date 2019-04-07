module Heimdallr
  module Token

    def self.included(base)
      base.extend ClassMethods
      base.instance_variable_set(:@claims, {})
    end

    module ClassMethods

      def from_request(request)

      end
    end

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
      @scopes ||= []
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

    # Encodes this token record into a JWT string.
    #
    # @return [String]
    def encode
      # raise StandardError, I18n.t(:not_persisted, scope: 'token.errors') unless persisted?
      # raise StandardError, I18n.t(:default_token, scope: 'token.errors') if default_token?

      payload = {
        iat: created_at.to_i,
        exp: expires_at.to_i,
        nbf: not_before.to_i,
        iss: Heimdallr.config.claims.issuer,
        aud: audience,
        sub: subject,
        jti: id
      }
      payload.delete_if { |_, value| value.nil? }

    end

    protected

    # Verifies that the token loaded from the database is valid and ready to be used.
    def verify_token_claims
      leeway = Heimdallr.config.expiration_leeway

    end
  end
end
