#!/usr/bin/env ruby

require 'rotp'

username = 'vpn_username_goes_here'
password = 'vpn_password_goes_here'

totp = ROTP::TOTP.new('totp_secret_goes_here')
current_token = totp.now

system("printf #{current_token} | pbcopy")  #if you have pbcoby it will add it to your clipboard.. otherwise just wipe it.

puts username
puts password
puts current_token
puts 31 - (Time.now.sec % 30)
