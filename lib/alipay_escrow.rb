require 'openssl'
require 'base64'
require 'active_support'
require 'httparty'

module AlipayEscrow
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Payment
  autoload :Refund
end
