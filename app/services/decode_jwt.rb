class DecodeJwt < ApplicationService
  def initialize(token)
    @token = token
  end

  def execute
    secret = "HOLA"
    decoded = JWT.decode(@token, secret)[0]
    return HashWithIndifferentAccess.new decoded    
  end

end