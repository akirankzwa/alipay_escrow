require 'alipay_escrow/version'
require 'openssl'
require 'base64'
require 'active_support'
require 'active_support/core_ext'
require 'httparty'

module AlipayEscrow
  class Refund
    attr_reader :params, :key, :partner_id
    attr_accessor :options

    GATEWAY = 'https://mapi.alipay.com/gateway.do?'

    def initialize(params, key, partner_id)
      @params = params
      @key = key
      @partner_id = partner_id
      @options = {}
    end

    def refund_url
      options = Hash[refund_params.map { |k, v| [k.to_s, v] }]
      str = options.sort.map { |item| item.join('=') }.join('&')
      options.merge!(sign_type: 'RSA', sign: encrypt(str))
      "#{GATEWAY}#{options.to_query}"
    end

    private

    def refund_params
      {
        batch_no: 'TODO',
        notify_url: params[:notify_url],
        service: 'refund_fastpay_by_platform_pwd',
        partner: partner_id,
        seller_user_id: partner_id,
        refund_date: Time.now.strftime('%F %T'),
        batch_num: 1,
        detail_data: "#{params[:trade_no]}^#{params[:amount]}^#{params[:reason]}"
      }
    end

    def encrypt(str)
      Base64.strict_encode64(OpenSSL::PKey::RSA.new(key).sign('sha1', str))
    end
  end
end
