
-- our first try at apples and scripting them...
-- free like beer

-- authors
-- awkwords http://github.com/awkwords
-- wdrexler http://github.com/wdrexler
-- jstremick http://github.com/jstremick

-- List all Viscosity profiles managed by this sript
set vpn_profiles to {"profile1", "profile2"}

-- auth_acript needs to be on your path and executable
global auth_script
set auth_script to "gettoken.rb"


to get_credentials()
  -- Expects 4 lines of output from auth_script
  -- 1. username
  -- 2. password
  -- 3. TOTP token
  -- 4. Seconds until next token
  set AppleScript's text item delimiters to {return & linefeed, return, linefeed, character id 8233, character id 8232}
  set creds to do shell script auth_script
  set credentials to creds's text items
  set AppleScript's text item delimiters to {""} -- restore delimiters to default value
  return credentials
end get_credentials


to wait_for_login_window(vpn_name)
  set the_timeout to 10
  set the_interval to 0.25

  tell application "System Events"
    repeat the_timeout / the_interval times
      tell process "Viscosity"
        if (count windows) is greater than 0 then
          repeat with the_window in windows
            if name of the_window is "Viscosity - " & vpn_name then return the_window
          end repeat
        end if
      end tell
      delay the_interval
    end repeat
  end tell

  return null
end wait_for_login_window


to display_in_window(the_text, the_window, the_field)
  tell application "System Events" to tell process "Viscosity"
    set value of text field the_field of the_window to the_text
  end tell
end display_in_window


to perform_login(creds, login_window)
  display_in_window(item 1 of creds, login_window, 1)
  display_in_window((item 2 of creds & item 3 of creds), login_window, 2)
  tell application "System Events" to tell process "Viscosity" to click button "OK" of login_window
end perform_login


to get_connection_state(conn)
  tell application "Viscosity" to repeat with the_connection in every connection
    if the name of the_connection is equal to conn then
      return state of the_connection
    end if
  end repeat

  return null
end get_connection_state


to display_notification(the_text)
  display notification (the_text) with title "Viscosity"
  delay 3
end display_notification



-- Main Program

tell application "Viscosity" to activate
set do_delay to false

repeat with vpn_profile_id from 1 to (count of vpn_profiles)
  set vpn_profile to item vpn_profile_id of vpn_profiles
  set state to get_connection_state(vpn_profile)

  if state is null then
    display_notification("Profile " & vpn_profile & " not found!")
    return
  end if

  if state is "Disconnected" then
    tell application "Viscosity" to connect vpn_profile

    set login_window to my wait_for_login_window(vpn_profile)

    if login_window is null then
      display_notification("Failed to initiate connection to " & vpn_profile)
      tell application "Viscosity" to disconnect vpn_profile
      return
    end if

    if do_delay then
      set wait to item 4 of creds as number
      repeat with i from wait to 1 by -1
        display_in_window("Next TOTP token in " & i, login_window, 1)
        delay 1
      end repeat
    end if

    set creds to my get_credentials()
    perform_login(creds, login_window)

    set do_delay to true
  end if
end repeat

