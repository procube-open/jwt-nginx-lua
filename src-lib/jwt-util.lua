local string = require("string")
local table = require("table")
local base = _G
local _M = {}
if module then -- heuristic for exporting a global package table
    jwtUtil = _M
end

function _M.toUnicode(a)
    a1,a2,a3,a4 = a:byte(1, -1)
    ans = string.format ("%%%02X", a1)
    n = a2
    if (n) then
        ans = ans .. string.format ("%%%02X", n)
    end
    n = a3
    if (n) then
        ans = ans .. string.format ("%%%02X", n)
    end
    n = a4
    if (n) then
        ans = ans .. string.format ("%%%02X", n)
    end
    return ans
end

function _M.urlencode(str)
    if (str) then
        -- str = string.gsub(str, "\\n", "\\r\\n")
        str = string.gsub(str, "([^%w ])", _M.toUnicode)
        str = string.gsub(str, " ", "+")
    end
    return str
end

function getFileExtension(filename)
  return filename:match("^.+(%..+)$")
end

function _M.decideContentType(template_filename)
  local ext = getFileExtension(template_filename)
  if (ext == ".html") then
    return "text/html"
  elseif (ext == ".json") then
    return "application/json"
  else
    ngx.log(ngx.ERR, "Unsupported extension " .. ext .. "")
    return "text/plain"
  end
end


return _M
