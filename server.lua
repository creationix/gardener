local createServer = require('coro-net').createServer

createServer(11000, function (read, write)
  for data in read do
    write(data)
  end
  write()
end)
print("TCP echo server listening at port 11000 on localhost")

createServer("check", function (_, write)
  write("Hello World\n")
  write()
end)

print("status socket pipe listening at 'check'")
