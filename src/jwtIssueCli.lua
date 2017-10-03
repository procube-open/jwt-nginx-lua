#!/usr/bin/lua

local jwt = require "luajwt"
local cjson = require "cjson"

local JWT_ENC_ALGORITHM = "HS256"

local mode_quiet = false

local debugInfo = debug.getinfo(1)
local fileName = debugInfo.source:match("[^/]*$")

function getopt( arg, options )
  local tab = {}
  for k, v in ipairs(arg) do
    if string.sub( v, 1, 2) == "--" then
      local x = string.find( v, "=", 1, true )
      if x then tab[ string.sub( v, 3, x-1 ) ] = string.sub( v, x+1 )
      else      tab[ string.sub( v, 3 ) ] = true
      end
    elseif string.sub( v, 1, 1 ) == "-" then
      local y = 2
      local l = string.len(v)
      local jopt
      while ( y <= l ) do
        jopt = string.sub( v, y, y )
        if string.find( options, jopt, 1, true ) then
          if y < l then
            tab[ jopt ] = string.sub( v, y+1 )
            y = l
          else
            tab[ jopt ] = arg[ k + 1 ]
          end
        else
          tab[ jopt ] = true
        end
        y = y + 1
      end
    end
  end
  return tab
end

function usage()
  print("usage: " .. fileName .. " -s <subjectValue> -e <expiration seconds> -k <key for encoding>")
  print([[
  -s
     Subject value. userID, mail-address expected.

  -e
    Expiration for JWT as seconds.

  -k
    Key (Secret) value for encoding JWT.

  -q
   Quiet mode. (no parameter) 
]])
end

function genPayload(subject, expSec)
  local payload = {
    sub = subject,
    nbf = os.time(),
    exp = os.time() + expSec,
  }
  return payload, err
end

function errorExit(message)
  print(message)
  os.exit(1)
end

function out_info(message)
  if not mode_quiet then
    print(message)
  end
end

function main()
  local opts = getopt(arg, "sek")

  local targetVal = opts.s
  local expSecStr = opts.e
  local secret = opts.k

  if not targetVal or not expSecStr or not secret then
    print("Missing required parameters")
    usage()
    return
  end

  mode_quiet = opts.q

  local expSec = tonumber(expSecStr)
  if not expSec then
    errorExit("Value of expiration-seconds must be numeric, but not. " .. expSecStr)
  end

  -- Generate JWT
  local payload = genPayload(targetVal, expSec)
  out_info("Generated payload is ==> " .. cjson.encode(payload))
  token, err = jwt.encode(payload, secret, JWT_ENC_ALGORITHM)
  if not token then
    -- Failed to generate JWT.
    errorExit("Failed to generate token : " .. err)
  end

  out_info("JWT issued successfully.")
  print(token)
end

main()

