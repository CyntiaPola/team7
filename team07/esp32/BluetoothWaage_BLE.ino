#include "HX711.h" // Wägezelle
#include <LiquidCrystal_I2C.h> // Display

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>

#define SERVICE_UUID        "833b84e9-85cc-4b29-b232-fb021341964d"
#define CHARACTERISTIC_UUID_TX "9a5d7e42-43c3-4e52-b0a2-7275084434bd"

#define CALIBRATION_FACTOR 403505 / 195

/**
  Bluetooth-Waage Hauptprogramm

  Display
  SDA - Pin 21
  SCL - Pin 22

  Wägezelle/HX711
  DT - Pin 18
  SCK - Pin 19
*/

int tare_button = 2;
int ble_button = 15;

LiquidCrystal_I2C lcd(0x27, 16, 2); // columns, row

HX711 scale;
const int DOUT_PIN = 18;
const int SCK_PIN = 19;

BLECharacteristic *pCharacteristic = NULL;
BLEServer *pServer = NULL;
BLEService *pService = NULL;
bool deviceConnected;
int gewicht = 0;
int ble_status = 1;

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };
    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      pServer->getAdvertising()->start();
    };
};


void setup() {
  Serial.begin(115200);

  pinMode(tare_button, INPUT_PULLDOWN);
  pinMode(ble_button, INPUT_PULLDOWN);

  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Gewicht:");
  lcd.setCursor(13, 0);
  lcd.print("BLE:");
  lcd.setCursor(13, 1);
  lcd.print(" ON");

  scale.begin(DOUT_PIN, SCK_PIN);
  scale.set_scale(CALIBRATION_FACTOR); // Wert zum kalibrieren
  scale.tare();
  
  // Create BLE Device
  BLEDevice::init("Bluetooth-Waage"); // Name
  
  // Create BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create BLE Service
  pService = pServer->createService(SERVICE_UUID);

  // Create BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID_TX,
                      BLECharacteristic::PROPERTY_NOTIFY);
                      
  // BLE2902 to notify
  pCharacteristic->addDescriptor(new BLE2902());

  // Start service
  pService->start();
  
  ble_on();
}

void ble_on(){
  // Start advertising
  pServer->getAdvertising()->start();
  Serial.println("Waiting for a client connection...");
}

void ble_off(){
  // Start advertising
  //BLEDevice::deinit(true); // Name
  Serial.println("Disconnected...");
}


void loop() {
  if (scale.is_ready()) {
    int new_reading = scale.get_units();
    Serial.print("HX711 hat folgendes gemessen: ");
    Serial.println(new_reading);
    if (gewicht != new_reading) {
      gewicht=new_reading;
      lcd.setCursor(0, 1);
      lcd.print("    ");
      lcd.setCursor(0, 1);
      lcd.print(gewicht);

      if (deviceConnected) {
        char txString[8];
        dtostrf(gewicht, 1, 2, txString);
        pCharacteristic->setValue(txString); // Send
        pCharacteristic->notify(); // Send
        Serial.println("Sent value" + String(txString));
      }
    }
  }

  if (digitalRead(tare_button) == HIGH) {
      lcd.setCursor(0, 1);
      lcd.print("0    ");
    Serial.println("tare...");
    scale.tare();
  }
  if (digitalRead(ble_button) == HIGH) {
    if(ble_status==0){
      ble_status=1;
      Serial.println("ble on...");
      ble_on();
      lcd.setCursor(13, 1);
      lcd.print(" ON");
      delay(500);
    }
    else if(ble_status==1){
      ble_status=0;
      Serial.println("ble off...");
      ble_off();
      lcd.setCursor(13, 1);
      lcd.print("OFF");
      delay(500);
    }
  }
  delay(10);
}
