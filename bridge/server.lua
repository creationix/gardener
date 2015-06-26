local createServer = require('coro-net').createServer
local uv = require('uv')

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
}, function (read, write, socket)
  p("Client connected", socket)
  local buffer = ""
  for data in read do
    buffer = buffer .. data
    while true do
      local line = buffer:match("^[^\n]*\n")
      if not line then break end
      buffer = buffer:sub(#line + 1)
      if line:match("^metric [^ ]+ [^ ]+ [^ ]") then
        local now = gmtNow()
        logs[#logs + 1] = "timestamp " .. now .. "\n"
        logs[#logs + 1] = line
        write("OK: " .. now .. "\n")
      else
        write("Invalid line: " .. line)
        return write()
      end
    end
    write(".\n")
  end
  p("Client disconnected", socket)
  return write()
end)
print("TCP echo server listening at port 11000 on localhost")

local path = "/var/run/gardener"
require('fs').unlinkSync(path)
createServer(path, function (_, write)
  p("status requested")
  local report = "status OK\n" .. table.concat(logs)
  logs = {}
  print(report)
  write(report)
  write()
end)
require('fs').chmod(path, 511)

print("status socket pipe listening at '" .. path .. "'")

print("Dropping to normal user...")
uv.setgid(1000)
uv.setuid(1000)
