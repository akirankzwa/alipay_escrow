require 'alipay_escrow/version'
require 'openssl'
require 'base64'
require 'active_support'
require 'active_support/core_ext'

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

    private

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
