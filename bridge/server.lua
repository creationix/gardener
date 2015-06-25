local createServer = require('coro-net').createServer


local logs = {}


-- Get ms since Jan. 1 1970 in GMT
local function gmtNow()
  local t_secs = os.time() -- get seconds if t was in local time.
  local t_UTC = os.date("!*t", t_secs) -- find out what UTC t was converted to.
  return os.time(t_UTC) * 1000 -- find out the converted time in milliseconds.
end

createServer({
  host = "0.0.0.0",
  port = 11000
}, function (read, write)
  local buffer = ""
  for data in read do
    buffer = buffer .. data
    while true do
      local line = buffer:match("^[^\n]*\n")
      if not line then return end
      if line:match("^metric [^ ]+ [^ ]") then
        local now = gmtNow()
        logs[#logs + 1] = "timestamp " .. now .. "\n"
        logs[#logs + 1] = line
        write("OK: " .. now .. "\n")
      else
        write("Invalid line: " .. line)
        return write()
      end
    end
  end
  return write()
end)
print("TCP echo server listening at port 11000 on localhost")

local path = "/var/run/gardener"
require('fs').unlinkSync(path)
createServer(path, function (_, write)
  write("status OK")
  write(table.concat(logs))
  logs = {}
  write()
end)

print("status socket pipe listening at '" .. path .. "'")
