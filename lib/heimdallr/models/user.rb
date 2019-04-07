module Heimdallr::Models
  module User
    extend ActiveSupport::Concern

    module ClassMethods

      def authenticate(*credentials, &block)
        raise ArgumentError, 'at least 2 arguments are required' if credentials.size < 2

      end
    end

    included do
      attr_reader   :password, :current_password
      attr_accessor :password_confirmation
    end

    # Password setter - automatically hashes the value argument.
    #
    # @param [String] value Cleartext password to hash.
    def password=(value)
      @password = value
      self.password = password_digest(@password) if @password.present?
    end

    # Checks whether or not the passed password matches.
    #
    # @param [String] value
    # @return [Boolean] Returns true if the password matches, false otherwise.
    def valid_password?(value)
      Argon2::Password.verify_password(value, password)
    end

    def update_with_password(params)
      current_password = params.delete(:current_password)

      if params[:password].blank?
        params.delete(:password)
        params.delete(:password_confirmation) if params[:password_confirmation].blank?
      end

      result = if valid_password?(current_password)
        update(params)
      else
        assign_attributes(params)
        valid?
        errors.add(:current_password, current_password.blank? ? :blank : :invalid)
        false
      end

      result
    end

    protected

    # Hashes a password using Argon2.
    #
    # @param [String] password The password to hash.
    # @return [String] Returns the hashed password.
    def password_digest(password)
      hasher = Argon2::Password.new
      hasher.create(password)
    end
  end
end
