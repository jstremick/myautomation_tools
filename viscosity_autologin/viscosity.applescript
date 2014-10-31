#our first try at apples and scripting them...
#free like beer

#authors
#awkwords http://github.com/awkwords
#wdrexler http://github.com/wdrexler
#jstremick http://github.com/jstremick

tell application "Viscosity" to activate
tell application "Viscosity" to connect "set to your vpn profile"

tell application "System Events"
  repeat with i from 1 to 5
    if exists window 0 of process "Viscosity" then
      exit repeat
    end if
    delay 1
  end repeat
end tell

set totp to do shell script "gettoken" # this is whatever binary you wrote to get your totp tokens.. see my gettoken script for example

log "password" & totp

tell application "System Events" to tell process "Viscosity"
  set value of text field 1 of window 0 to "humungusdingus"
  set value of text field 2 of window 0 to "password" & totp
  click button "OK" of window 0
end tell
