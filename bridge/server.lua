local createServer = require('coro-net').createServer

createServer({
  host = "0.0.0.0",
  port = 11000
}, function (read, write)
  for data in read do
    p(data)
    write(data)
  end
  write()
end)
print("TCP echo server listening at port 11000 on localhost")

require('fs').unlinkSync("check")
createServer("check", function (_, write)
  write("Hello World\n")
  write()
end)

print("status socket pipe listening at 'check'")
