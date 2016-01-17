module AlipayEscrow
  class Base
    attr_reader :params, :key, :partner_id
    attr_accessor :options

    GATEWAY = 'https://mapi.alipay.com/gateway.do?'

    def initialize(params, key, partner_id)
      @params = params
      @key = key
      @partner_id = partner_id
      @options = {}
    end

    def verify
      signature_verify && notification_verify
    end

    private

    def signature_verify
      params.delete('sign_type')
      signature = params.delete('sign')
      data = params.sort.map { |item| item.join('=') }.join('&')
      rsa = OpenSSL::PKey::RSA.new(key)
      rsa.verify('sha1', Base64.strict_decode64(signature), data)
    end

    def notification_verify
      query_params = {
        'service' => 'notify_verify',
        'partner' => partner_id,
        'notify_id' => params['notify_id']
      }
      HTTParty.get("#{GATEWAY}#{query_params.to_query}")
    end

    def encrypt(str)
      Base64.strict_encode64(OpenSSL::PKey::RSA.new(key).sign('sha1', str))
    end
  end
end
