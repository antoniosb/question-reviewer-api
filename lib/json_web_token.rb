class JsonWebToken
  class << self
    def encode params, exp = 24.hours.from_now
      payload = { data: params, exp: exp.to_i }
      JWT.encode(payload, Rails.application.secret_key_base)
    end

    def decode(token)
      JWT.decode(token, Rails.application.secret_key_base)[0]["data"]
    rescue
      nil
    end
  end
 end