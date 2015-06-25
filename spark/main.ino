SYSTEM_MODE(MANUAL);

TCPClient client;

void setup() {
  Serial.begin(9600);
  pinMode(A0, INPUT);
  WiFi.on();
  WiFi.connect();
  while (!WiFi.ready()) Spark.process();
}

IPAddress server = { 192, 168, 1, 144 };
int port = 11000;

void loop() {

  IPAddress myIP = WiFi.localIP();
  Serial.println(myIP);    // prints the device's IP address

  Serial.println("connecting...");
  Serial.print("Ip: ");
  Serial.println(server);
  Serial.print("Port: ");
  Serial.println(port);

  if (client.connect(server, port))
  {
    Serial.println("connected");
    int light = analogRead(A0);
    String data = String("light-rainbowdash int ") + String(light, DEC) + "\n";
    Serial.print(data);
    client.print(data);

    delay(1000);
    Spark.sleep(SLEEP_MODE_DEEP, 5);

  }
  else
  {
    Serial.println("connection failed, trying again in 5 seconds");
    delay(5000);
  }


}
