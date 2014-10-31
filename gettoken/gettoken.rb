#!/usr/bin/env ruby
#grabs my current token
#free like beer
#authors
#awkords
require 'rotp'
token = 'xxxxxxxxxxx' #USE YOUR TOTP SEED HERE!!
totp = ROTP::TOTP.new(token)
current_token = totp.now
system("printf #{current_token} | pbcopy")  #if you have pbcoby it will add it to your clipboard.. otherwise just wipe it.
puts "#{current_token}"
