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
int tries = 0;

void loop() {

  IPAddress myIP = WiFi.localIP();
  Serial.println(myIP);    // prints the device's IP address

  Serial.println("connecting...");
  Serial.print("Ip: ");
  Serial.println(server);
  Serial.print("Port: ");
  Serial.println(port);

  if (client.connect(server, port)) {
    Serial.println("connected");
    int light = analogRead(A0);
    String data = String("metric light-rainbowdash int ") + String(light, DEC) + "\n";
    Serial.print(data);
    client.print(data);
    delay(1000);
    client.stop();
    Spark.sleep(SLEEP_MODE_DEEP, 30);
  }
  else {
    tries = tries + 1;
    if (tries < 5) {
      Serial.println("connection failed, trying again in 5 seconds");
      delay(5000);
    }
    else {
      Serial.println("connection failed 5 times, sleeping for 1 minute");
      delay(5000);
      Spark.sleep(SLEEP_MODE_DEEP, 55);
    }
  }
}
