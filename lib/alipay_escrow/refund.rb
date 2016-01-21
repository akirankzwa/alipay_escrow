module AlipayEscrow
  class Refund < Base
    def refund_url
      options = Hash[refund_params.map { |k, v| [k.to_s, v] }]
      str = options.sort.map { |item| item.join('=') }.join('&')
      options.merge!(sign_type: 'RSA', sign: encrypt(str))
      "#{GATEWAY}#{options.to_query}"
    end

    private

    def refund_params
      {
        batch_no: format("%0#{24}d", SecureRandom.random_number(10**24)),
        notify_url: params['notify_url'],
        service: 'refund_fastpay_by_platform_pwd',
        partner: partner_id,
        seller_user_id: partner_id,
        refund_date: Time.now.strftime('%F %T'),
        batch_num: 1,
        detail_data: "#{params['trade_no']}^#{params['amount']}^#{params['reason']}",
        _input_charset: 'utf-8'
      }
    end
  end
end
