module AlipayEscrow
  class Payment < Base
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
  end
end
