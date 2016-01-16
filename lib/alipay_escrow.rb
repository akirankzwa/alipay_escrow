require 'alipay_escrow/version'
require 'openssl'
require 'base64'
require 'active_support'
require 'active_support/core_ext'
require 'httparty'

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

    def payment_url
      options = Hash[payment_params.map { |k, v| [k.to_s, v] }]
      str = options.sort.map { |item| item.join('=') }.join('&')
      options.merge!(sign_type: 'RSA', sign: encrypt(str))
      "#{GATEWAY}#{options.to_query}"
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

    def payment_params
      {
        out_trade_no: params[:trade_no],
        subject: params[:subject],
        total_fee: params[:amount].to_s,
        return_url: params[:return_url],
        notify_url: params[:notify_url],
        service: 'create_direct_pay_by_user',
        partner: partner_id,
        seller_id: partner_id,
        payment_type: '1',
        _input_charset: 'utf-8'
      }
    end

    def encrypt(str)
      Base64.strict_encode64(OpenSSL::PKey::RSA.new(key).sign('sha1', str))
    end
  end
end
