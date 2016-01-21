# AlipayEscrow

AlipayEscrow is a Ruby Interface to Alipay Payment Gateway. Uunofficial. It supports:

* create_direct_pay_by_user
* refund_fastpay_by_platform_pwd
* notify_verify
* RSA, ~~DSA~~, ~~MD5~~

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alipay_escrow'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alipay_escrow

## Usage

create_direct_pay_by_user:

    $ pid = 'YOUR PARTNER ID'
    $ key = File.read('YOUR RSA PRIVATE KEY')
    $ params = {
    $   trade_no: 'TRANSACTION ID',
    $   subject:  'SUBJECT',
    $   amount:   'TOTAL PRICE',
    $   return_url: 'RETURN URL',
    $   notify_url: 'NOTIFY URL'
    $ }
    $ escrow = AlipayEscrow::Payment.new(params, key, pid)
    $ escrow.payment_url # => https://mapi.alipay.com/gateway.do?_input_charset=utf-8&notify_url=http%3A%2F%2Fexample.comn%2F&out_trade_no=20160121173854779843000&partner=...&payment_type=1&return_url=https%3A%2F%2Fexample.com%2Falipay%2Fasync_notify&seller_id=...&service=create_direct_pay_by_user&sign=...%3D&sign_type=RSA&subject=iPhone6S&total_fee=2900

refund_fastpay_by_platform_pwd:

    $ pid = 'YOUR PARTNER ID'
    $ key = File.read('YOUR RSA PRIVATE KEY')
    $ params # => {
    $   'notify_url' => 'NOTIFY URL',
    $   'trade_no'   => 'TRADE NO',
    $   'amount'     => '2900',
    $   'reason'     => 'refund reason'
    $ }
    $ escrow = AlipayEscrow::Refund.new(params, key, pid)
    $ escrow.refund_url # => https://mapi.alipay.com/gateway.do?_input_charset=utf-8&batch_no=540460171869518393124404&batch_num=1&detail_data=20160114...%5E2900%5Erefund+reason&notify_url=https%3A%2F%2Fexample.com%2Falipay%2Fasync_notify&partner=...&refund_date=2016-01-21+19%3A21%3A30&seller_user_id=...&service=refund_fastpay_by_platform_pwd&sign=TRlEoMVu2Dyj...&sign_type=RSA

notify_verify:

    # POST params from Alipay
    $ params # => {
    $   "sign"           => "Znkt3YzO2kmf...",
    $   "result_details" => "20160120...^2900^SUCCESS",
    $   "notify_time"    => "2016-01-21 12:14:07",
    $   "sign_type"      => "RSA",
    $   "notify_type"    => "batch_refund_notify",
    $   "notify_id"      => "1d8e3ad3164...",
    $   "batch_no"       => "20160121121...",
    $   "success_num"    => "1"
    $ }
    $ pid = 'YOUR PARTNER ID'
    $ key = File.read('ALIPAY RSA PUBLIC KEY')
    $ escrow = AlipayEscrow::Refund.new(params, key, pid)
    $ escrow.verified? # => true/false

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/alipay_escrow. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
