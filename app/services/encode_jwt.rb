class EncodeJwt < ApplicationService
  def initialize(payload)
    @payload = payload
  end

  def execute
    secret = "HOLA"
    @payload[:exp] = 24.hours.from_now.to_i
    return JWT.encode(@payload, secret)
  end
end