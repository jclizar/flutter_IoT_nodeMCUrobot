//            头
//   ----             ----
// | 02/4 |         | 15/8 |
//   ----  --------   ----
//       | 04/2  13/7 |
//       |            |
//       | 05/1  12/6 |
//   ----  --------   ----
// | 16/0 |         | 14/5 |
//   ----             ----

#include <Servo.h>
#include <EEPROM.h>
#include <ESP8266WiFi.h>

// -------------------------------------------------------------------------------- Dibop

// --- WIFI CONFIG ---
const char* ssid = "yourssid"; // troque pelo nome da sua rede
const char* password = "yourpassword"; // troque pela senha da sua rede

WiFiClient nodemcuClient;


// --- MQTT ---
#include <PubSubClient.h>
const char* mqtt_Broker = "mqtt.eclipseprojects.io";
PubSubClient client(nodemcuClient);
const char* topicoController = "dibop/controller0";
const char* topicoConnect = "dibop/connect";
const char* mqtt_ClientID = "dibop01";

void conectarWifi() {
  //delay(10);

  //Serial.println();
  //Serial.print("Connecting to ");
  //Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
}

/* Exibindo somente a função 
reconectarMQTT(), omitindo o 
restante do código */

void reconectarMQTT() {
  while (!client.connected()) {
    if (client.connect(mqtt_ClientID)) {   
      //client.publish(topicoConnect, "ONLINE");
    }
    else{
      delay(5000);
    }
  }
}
// -------------------------------------------------------------------------------- Dibop - FIM

// Firmware version
String FW_Version = "科睿 - 小蜘蛛 v1.0";

// Servos matrix
const int ALLMATRIX = 9; // GPIO14 + GPIO12 + GPIO13 + GPIO15 + GPIO16 + GPIO5 + GPIO4 + GPIO2 + Run Time
const int ALLSERVOS = 8; // GPIO14 + GPIO12 + GPIO13 + GPIO15 + GPIO16 + GPIO5 + GPIO4 + GPIO2

// MG90S servo PWM pulse traveling
const int PWMRES_Min = 1; // PWM Resolution 1
const int PWMRES_Max = 180; // PWM Resolution 180
const int SERVOMIN = 400; // 400
const int SERVOMAX = 2400; // 2400

// Servo delay base time
const int BASEDELAYTIME = 10; // 10 ms

// AP password
const char WiFiAPPSK[] = "12345678";

// Motion data index
long Servo_PROGRAM;


// Servo ID
int GPIO_ID;
int GPIO14_PWM;
int GPIO12_PWM;
int GPIO13_PWM;
int GPIO15_PWM;
int GPIO16_PWM;
int GPIO5_PWM;
int GPIO4_PWM;
int GPIO2_PWM;

int Running_Servo_POS [ALLMATRIX];

ESP8266WebServer server(80);

Servo GPIO14SERVO;
Servo GPIO12SERVO;
Servo GPIO13SERVO;
Servo GPIO15SERVO;
Servo GPIO16SERVO;
Servo GPIO5SERVO;
Servo GPIO4SERVO;
Servo GPIO2SERVO;



// Action
// --------------------------------------------------------------------------------

// Servo zero position 歸零位置
// ----------------------------- G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
int Servo_Act_0 [ ] PROGMEM = {  135,  45, 135,  45,  45, 135,  45, 135,  500  };

// Start position 起始位置
// ----------------------------- G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
int Servo_Act_1 [ ] PROGMEM = {  135,  45, 135,  45,  45, 135,  45, 135,  500  };

// Standby 待機
int Servo_Prg_1_Step = 2;
int Servo_Prg_1 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   90,  90,  90,  90,  90,  90,  90,  90,  500  }, // servo center point
  {   70,  90,  90, 110, 110,  90,  90,  70,  500  }, // standby
};

// Forward 前行
int Servo_Prg_2_Step = 11;
int Servo_Prg_2 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   70,  90,  90, 110, 110,  90,  90,  70,  200  }, // standby
  {   90,  90,  90, 110, 110,  90,  45,  90,  200  }, // leg1,4 up; leg4 fw
  {   70,  90,  90, 110, 110,  90,  45,  70,  200  }, // leg1,4 dn
  {   70,  90,  90,  90,  90,  90,  45,  70,  200  }, // leg2,3 up
  {   70,  45, 135,  90,  90,  90,  90,  70,  200  }, // leg1,4 bk; leg2 fw
  {   70,  45, 135, 110, 110,  90,  90,  70,  200  }, // leg2,3 dn
  {   90,  90, 135, 110, 110,  90,  90,  90,  200  }, // leg1,4 up; leg1 fw
  {   90,  90,  90, 110, 110, 135,  90,  90,  200  }, // leg2,3 bk
  {   70,  90,  90, 110, 110, 135,  90,  70,  200  }, // leg1,4 dn
  {   70,  90,  90, 110,  90, 135,  90,  70,  200  }, // leg3 up
  {   70,  90,  90, 110, 110,  90,  90,  70,  200  }, // leg3 fw dn
};

// Backward 退後
int Servo_Prg_3_Step = 11;
int Servo_Prg_3 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   70,  90,  90, 110, 110,  90,  90,  70,  200  }, // standby
  {   90,  45,  90, 110, 110,  90,  90,  90,  200  }, // leg4,1 up; leg1 fw
  {   70,  45,  90, 110, 110,  90,  90,  70,  200  }, // leg4,1 dn
  {   70,  45,  90,  90,  90,  90,  90,  70,  200  }, // leg3,2 up
  {   70,  90,  90,  90,  90, 135,  45,  70,  200  }, // leg4,1 bk; leg3 fw
  {   70,  90,  90, 110, 110, 135,  45,  70,  200  }, // leg3,2 dn
  {   90,  90,  90, 110, 110, 135,  90,  90,  200  }, // leg4,1 up; leg4 fw
  {   90,  90, 135, 110, 110,  90,  90,  90,  200  }, // leg3,1 bk
  {   70,  90, 135, 110, 110,  90,  90,  70,  200  }, // leg4,1 dn
  {   70,  90, 135,  90, 110,  90,  90,  70,  200  }, // leg2 up
  {   70,  90,  90, 110, 110,  90,  90,  70,  200  }, // leg2 fw dn
};

// Left shift 左移
int Servo_Prg_4_Step = 11;
int Servo_Prg_4 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   70,  90,  90, 110, 110,  90,  90,  70,  200  }, // standby
  {   70,  90,  45,  90,  90,  90,  90,  70,  200  }, // leg3,2 up; leg2 fw
  {   70,  90,  45, 110, 110,  90,  90,  70,  200  }, // leg3,2 dn
  {   90,  90,  45, 110, 110,  90,  90,  90,  200  }, // leg1,4 up
  {   90, 135,  90, 110, 110,  45,  90,  90,  200  }, // leg3,2 bk; leg1 fw
  {   70, 135,  90, 110, 110,  45,  90,  70,  200  }, // leg1,4 dn
  {   70, 135,  90,  90,  90,  90,  90,  70,  200  }, // leg3,2 up; leg3 fw
  {   70,  90,  90,  90,  90,  90, 135,  70,  200  }, // leg1,4 bk
  {   70,  90,  90, 110, 110,  90, 135,  70,  200  }, // leg3,2 dn
  {   70,  90,  90, 110, 110,  90, 135,  90,  200  }, // leg4 up
  {   70,  90,  90, 110, 110,  90,  90,  70,  200  }, // leg4 fw dn
};

// Right shift 右移
int Servo_Prg_5_Step = 11;
int Servo_Prg_5 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   70,  90,  90, 110, 110,  90,  90,  70,  200  }, // standby
  {   70,  90,  90,  90,  90,  45,  90,  70,  200  }, // leg2,3 up; leg3 fw
  {   70,  90,  90, 110, 110,  45,  90,  70,  200  }, // leg2,3 dn
  {   90,  90,  90, 110, 110,  45,  90,  90,  200  }, // leg4,1 up
  {   90,  90,  45, 110, 110,  90, 135,  90,  200  }, // leg2,3 bk; leg4 fw
  {   70,  90,  45, 110, 110,  90, 135,  70,  200  }, // leg4,1 dn
  {   70,  90,  90,  90,  90,  90, 135,  70,  200  }, // leg2,3 up; leg2 fw
  {   70, 135,  90,  90,  90,  90,  90,  70,  200  }, // leg4,1 bk
  {   70, 135,  90, 110, 110,  90,  90,  70,  200  }, // leg2,3 dn
  {   90, 135,  90, 110, 110,  90,  90,  70,  200  }, // leg1 up
  {   70,  90,  90, 110, 110,  90,  90,  70,  200  }, // leg1 fw dn
};

// Turn left 左轉leg
int Servo_Prg_6_Step = 8;
int Servo_Prg_6 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   70,  90,  90, 110, 110,  90,  90,  70,  200  }, // standby
  {   90,  90,  90, 110, 110,  90,  90,  90,  200  }, // leg1,4 up
  {   90, 135,  90, 110, 110,  90, 135,  90,  200  }, // leg1,4 turn
  {   70, 135,  90, 110, 110,  90, 135,  70,  200  }, // leg1,4 dn
  {   70, 135,  90,  90,  90,  90, 135,  70,  200  }, // leg2,3 up
  {   70, 135, 135,  90,  90, 135, 135,  70,  200  }, // leg2,3 turn
  {   70, 135, 135, 110, 110, 135, 135,  70,  200  }, // leg2,3 dn
  {   70,  90,  90, 110, 110,  90,  90,  70,  200  }, // leg1,2,3,4 turn
};

// Turn right 右轉
int Servo_Prg_7_Step = 8;
int Servo_Prg_7 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   70,  90,  90, 110, 110,  90,  90,  70,  200  }, // standby
  {   70,  90,  90,  90,  90,  90,  90,  70,  200  }, // leg2,3 up
  {   70,  90,  45,  90,  90,  45,  90,  70,  200  }, // leg2,3 turn
  {   70,  90,  45, 110, 110,  45,  90,  70,  200  }, // leg2,3 dn
  {   90,  90,  45, 110, 110,  45,  90,  90,  200  }, // leg1,4 up
  {   90,  45,  45, 110, 110,  45,  45,  90,  200  }, // leg1,4 turn
  {   70,  45,  45, 110, 110,  45,  45,  70,  200  }, // leg1,4 dn
  {   70,  90,  90, 110, 110,  90,  90,  70,  200  }, // leg1,2,3,4 turn
};

// Lie 趴地
int Servo_Prg_8_Step = 1;
int Servo_Prg_8 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {  110,  90,  90,  70,  70,  90,  90, 110,  500  }, // leg1,4 up
};

// Say Hi 打招呼
int Servo_Prg_9_Step = 7;
int Servo_Prg_9 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   70,  90,  90,  90,  90,  90,  90,  90,  400}, // leg2,3,4 dn
  {  170,  90,  90,  90,  90,  90,  90,  90,  400}, // leg1 up
  {  170, 130,  90,  90,  90,  90,  90,  90,  400}, // leg1 left
  {  170,  50,  90,  90,  90,  90,  90,  90,  400}, // leg1 right
  {  170, 130,  90,  90,  90,  90,  90,  90,  400}, // leg1 left
  {  170,  90,  90,  90,  90,  90,  90,  90,  400}, // leg1 right
  {   70,  90,  90,  90,  90,  90,  90,  90,  400}, // leg1 dn
};

// Fighting 戰鬥姿態
int Servo_Prg_10_Step = 11;
int Servo_Prg_10 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {  120,  90,  90, 110,  60,  90,  90,  70,  500  }, // leg1, 2 down
  {  120,  70,  70, 110,  60,  70,  70,  70,  500  }, // body turn left
  {  120, 110, 110, 110,  60, 110, 110,  70,  500  }, // body turn right
  {  120,  70,  70, 110,  60,  70,  70,  70,  500  }, // body turn left
  {  120, 110, 110, 110,  60, 110, 110,  70,  500  }, // body turn right
  {   70,  90,  90,  70, 110,  90,  90, 110,  500  }, // leg1, 2 up ; leg3, 4 down
  {   70,  70,  70,  70, 110,  70,  70, 110,  500  }, // body turn left
  {   70, 110, 110,  70, 110, 110, 110, 110,  500  }, // body turn right
  {   70,  70,  70,  70, 110,  70,  70, 110,  500  }, // body turn left
  {   70, 110, 110,  70, 110, 110, 110, 110,  500  }, // body turn right
  {   70,  90,  90,  70, 110,  90,  90, 110,  500  }  // leg1, 2 up ; leg3, 4 down
};

// Push up 掌上壓
int Servo_Prg_11_Step = 11;
int Servo_Prg_11 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   70,  90,  90, 110, 110,  90,  90,  70,  500  }, // start
  {  100,  90,  90,  80,  80,  90,  90, 100,  600  }, // down
  {   70,  90,  90, 110, 110,  90,  90,  70,  700  }, // up
  {  100,  90,  90,  80,  80,  90,  90, 100,  800  }, // down
  {   70,  90,  90, 110, 110,  90,  90,  70,  900  }, // up
  {  100,  90,  90,  80,  80,  90,  90, 100, 1500  }, // down
  {   70,  90,  90, 110, 110,  90,  90,  70, 2000  }, // up
  {  135,  90,  90,  45,  45,  90,  90, 135,  200  }, // fast down
  {   70,  90,  90,  45,  60,  90,  90, 135,  800  }, // leg1 up
  {   70,  90,  90,  45, 110,  90,  90, 135,  800  }, // leg2 up
  {   70,  90,  90, 110, 110,  90,  90,  70,  800  }  // leg3, leg4 up
};

// Sleep 睡眠姿勢
int Servo_Prg_12_Step = 2;
int Servo_Prg_12 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   30,  90,  90, 150, 150,  90,  90,  30,  500  }, // leg1,4 dn
  {   30,  45, 135, 150, 150, 135,  45,  30,  500  }, // protect myself
};

// 舞步 1
int Servo_Prg_13_Step = 10;
int Servo_Prg_13 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   90,  90,  90,  90,  90,  90,  90,  90,  400  }, // leg1,2,3,4 up
  {   50,  90,  90,  90,  90,  90,  90,  90,  400  }, // leg1 dn
  {   90,  90,  90, 130,  90,  90,  90,  90,  400  }, // leg1 up; leg2 dn
  {   90,  90,  90,  90,  90,  90,  90,  50,  400  }, // leg2 up; leg4 dn
  {   90,  90,  90,  90, 130,  90,  90,  90,  400  }, // leg4 up; leg3 dn
  {   50,  90,  90,  90,  90,  90,  90,  90,  400  }, // leg3 up; leg1 dn
  {   90,  90,  90, 130,  90,  90,  90,  90,  400  }, // leg1 up; leg2 dn
  {   90,  90,  90,  90,  90,  90,  90,  50,  400  }, // leg2 up; leg4 dn
  {   90,  90,  90,  90, 130,  90,  90,  90,  400  }, // leg4 up; leg3 dn
  {   90,  90,  90,  90,  90,  90,  90,  90,  400  }, // leg3 up
};

// 舞步 2
int Servo_Prg_14_Step = 9;
int Servo_Prg_14 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   70,  45, 135, 110, 110, 135,  45,  70,  400  }, // leg1,2,3,4 two sides
  {  115,  45, 135,  65, 110, 135,  45,  70,  400  }, // leg1,2 up
  {   70,  45, 135, 110,  65, 135,  45, 115,  400  }, // leg1,2 dn; leg3,4 up
  {  115,  45, 135,  65, 110, 135,  45,  70,  400  }, // leg3,4 dn; leg1,2 up
  {   70,  45, 135, 110,  65, 135,  45, 115,  400  }, // leg1,2 dn; leg3,4 up
  {  115,  45, 135,  65, 110, 135,  45,  70,  400  }, // leg3,4 dn; leg1,2 up
  {   70,  45, 135, 110,  65, 135,  45, 115,  400  }, // leg1,2 dn; leg3,4 up
  {  115,  45, 135,  65, 110, 135,  45,  70,  400  }, // leg3,4 dn; leg1,2 up
  {   75,  45, 135, 105, 110, 135,  45,  70,  400  }, // leg1,2 dn
};

// 舞步 3
int Servo_Prg_15_Step = 10;
int Servo_Prg_15 [][ALLMATRIX] PROGMEM = {
  // G14, G12, G13, G15, G16,  G5,  G4,  G2,  ms
  {   70,  45,  45, 110, 110, 135, 135,  70,  400  }, // leg1,2,3,4 bk
  {  110,  45,  45,  60,  70, 135, 135,  70,  400  }, // leg1,2,3 up
  {   70,  45,  45, 110, 110, 135, 135,  70,  400  }, // leg1,2,3 dn
  {  110,  45,  45, 110,  70, 135, 135, 120,  400  }, // leg1,3,4 up
  {   70,  45,  45, 110, 110, 135, 135,  70,  400  }, // leg1,3,4 dn
  {  110,  45,  45,  60,  70, 135, 135,  70,  400  }, // leg1,2,3 up
  {   70,  45,  45, 110, 110, 135, 135,  70,  400  }, // leg1,2,3 dn
  {  110,  45,  45, 110,  70, 135, 135, 120,  400  }, // leg1,3,4 up
  {   70,  45,  45, 110, 110, 135, 135,  70,  400  }, // leg1,3,4 dn
  {   70,  90,  90, 110, 110,  90,  90,  70,  400  }, // standby
};

// --------------------------------------------------------------------------------



// Servo
// --------------------------------------------------------------------------------

void Set_PWM_to_Servo(int iServo, int iValue)
{
  // 讀取 EEPROM 修正誤差
  int NewPWM = iValue + (int8_t)EEPROM.read(iServo);

  NewPWM = map(NewPWM, PWMRES_Min, PWMRES_Max, SERVOMIN, SERVOMAX);

  if (iServo >= 7) {
    GPIO2SERVO.write(NewPWM);
  } else if (iServo >= 6) {
    GPIO4SERVO.write(NewPWM);
  } else if (iServo >= 5) {
    GPIO5SERVO.write(NewPWM);
  } else if (iServo >= 4) {
    GPIO16SERVO.write(NewPWM);
  } else if (iServo >= 3) {
    GPIO15SERVO.write(NewPWM);
  } else if (iServo >= 2) {
    GPIO13SERVO.write(NewPWM);
  } else if (iServo >= 1) {
    GPIO12SERVO.write(NewPWM);
  } else if (iServo == 0) {
    GPIO14SERVO.write(NewPWM);
  }
}

void Servo_PROGRAM_Zero()
{
  // 清除備份目前馬達數值
  for (int Index = 0; Index < ALLMATRIX; Index++) {
    Running_Servo_POS[Index] = Servo_Act_0[Index];
  }

  // 重新載入馬達預設數值
  for (int iServo = 0; iServo < ALLSERVOS; iServo++) {
    Set_PWM_to_Servo(iServo, Running_Servo_POS[iServo]);
    delay(10);
  }
}

void Servo_PROGRAM_Center()
{
  // 清除備份目前馬達數值
  for (int Index = 0; Index < ALLMATRIX; Index++) {
    Running_Servo_POS[Index] = Servo_Act_1[Index];
  }

  // 重新載入馬達預設數值
  for (int iServo = 0; iServo < ALLSERVOS; iServo++) {
    Set_PWM_to_Servo(iServo, Running_Servo_POS[iServo]);
    delay(10);
  }
}

void Servo_PROGRAM_Run(int iMatrix[][9], int iSteps)
{
  int INT_TEMP_A, INT_TEMP_B, INT_TEMP_C;

  for (int MainLoopIndex = 0; MainLoopIndex < iSteps; MainLoopIndex++) { // iSteps 步驟主迴圈

    int InterTotalTime = iMatrix[MainLoopIndex][ALLMATRIX - 1]; // InterTotalTime 此步驟總時間

    int InterDelayCounter = InterTotalTime / BASEDELAYTIME; // InterDelayCounter 此步驟基本延遲次數

    for (int InterStepLoop = 0; InterStepLoop < InterDelayCounter; InterStepLoop++) { // 內差次數迴圈

      for (int ServoIndex = 0; ServoIndex < ALLSERVOS; ServoIndex++) { // 馬達主迴圈

        INT_TEMP_A = Running_Servo_POS[ServoIndex]; // 馬達現在位置
        INT_TEMP_B = iMatrix[MainLoopIndex][ServoIndex]; // 馬達目標位置

        if (INT_TEMP_A == INT_TEMP_B) { // 馬達數值不變
          INT_TEMP_C = INT_TEMP_B;
        } else if (INT_TEMP_A > INT_TEMP_B) { // 馬達數值減少
          INT_TEMP_C =  map(BASEDELAYTIME * InterStepLoop, 0, InterTotalTime, 0, INT_TEMP_A - INT_TEMP_B); // PWM內差值 = map(執行次數時間累加, 開始時間, 結束時間, 內差起始值, 內差最大值)
          if (INT_TEMP_A - INT_TEMP_C >= INT_TEMP_B) {
            Set_PWM_to_Servo(ServoIndex, INT_TEMP_A - INT_TEMP_C);
          }
        } else if (INT_TEMP_A < INT_TEMP_B) { // 馬達數值增加
          INT_TEMP_C =  map(BASEDELAYTIME * InterStepLoop, 0, InterTotalTime, 0, INT_TEMP_B - INT_TEMP_A); // PWM內差值 = map(執行次數時間累加, 開始時間, 結束時間, 內差起始值, 內差最大值)
          if (INT_TEMP_A + INT_TEMP_C <= INT_TEMP_B) {
            Set_PWM_to_Servo(ServoIndex, INT_TEMP_A + INT_TEMP_C);
          }
        }

      }

      delay(BASEDELAYTIME);
    }

    // 備份目前馬達數值
    for (int Index = 0; Index < ALLMATRIX; Index++) {
      Running_Servo_POS[Index] = iMatrix[MainLoopIndex][Index];
    }
  }
}

void writeKeyValue(int8_t key, int8_t value)
{
  EEPROM.write(key, value);
  EEPROM.commit();
}

int8_t readKeyValue(int8_t key)
{
  Serial.println("read");
  Serial.println(key);

  int8_t value = EEPROM.read(key);
}

// --------------------------------------------------------------------------------



// Handle
// --------------------------------------------------------------------------------

void handleAction(WiFiClient client, String req, HTTPMethod method)
{
  server.send(200, "text/plain", "Hello!");
}

void handleSave()
{
  String key = server.arg("key");
  String value = server.arg("value");

  int8_t keyInt = key.toInt();
  int8_t valueInt = value.toInt();

  // Software PWM PIN detach
  GPIO14SERVO.detach();
  GPIO12SERVO.detach();
  GPIO13SERVO.detach();
  GPIO15SERVO.detach();
  GPIO16SERVO.detach();
  GPIO5SERVO.detach();
  GPIO4SERVO.detach();
  GPIO2SERVO.detach();
  delay(50);

  if (keyInt == 100) {
    writeKeyValue(0, 0);
    writeKeyValue(1, 0);
    writeKeyValue(2, 0);
    writeKeyValue(3, 0);
    writeKeyValue(4, 0);
    writeKeyValue(5, 0);
    writeKeyValue(6, 0);
    writeKeyValue(7, 0);
  } else {
    if (valueInt >= -124 && valueInt <= 124) { // 確認資料介於 -124 ~ 124
      writeKeyValue(keyInt, valueInt); // 儲存校正值
    }
  }

  // Software PWM PIN attach
  GPIO14SERVO.attach(16, SERVOMIN, SERVOMAX);
  GPIO12SERVO.attach(5, SERVOMIN, SERVOMAX);
  GPIO13SERVO.attach(4, SERVOMIN, SERVOMAX);
  GPIO15SERVO.attach(2, SERVOMIN, SERVOMAX);
  GPIO16SERVO.attach(14, SERVOMIN, SERVOMAX);
  GPIO5SERVO.attach(12, SERVOMIN, SERVOMAX);
  GPIO4SERVO.attach(13, SERVOMIN, SERVOMAX);
  GPIO2SERVO.attach(15, SERVOMIN, SERVOMAX);
  delay(10);

  server.send(200, "text/html", "(key, value)=(" + key + "," + value + ")");
}

void handleController()
{
  String pm = server.arg("pm");
  String servo = server.arg("servo");

  if (pm != "") {
    Servo_PROGRAM = pm.toInt();
  }

  if (servo != "") {
    GPIO_ID = servo.toInt();
    String ival = server.arg("value");
    Set_PWM_to_Servo(GPIO_ID, ival.toInt());
  }

  server.send(200, "text/html", "(pm)=(" + pm + ")");
}

void handleOnLine()
{
  String m0 = server.arg("m0");
  String m1 = server.arg("m1");
  String m2 = server.arg("m2");
  String m3 = server.arg("m3");
  String m4 = server.arg("m4");
  String m5 = server.arg("m5");
  String m6 = server.arg("m6");
  String m7 = server.arg("m7");
  String t1 = server.arg("t1");

  int Servo_Prg_tmp [][ALLMATRIX] = {
    // GPIO14,     GPIO12,     GPIO13,     GPIO15,     GPIO16,     GPIO5,      GPIO4,      GPIO2,      Run Time
    { m0.toInt(), m1.toInt(), m2.toInt(), m3.toInt(), m4.toInt(), m5.toInt(), m6.toInt(), m7.toInt(), t1.toInt() }
  };

  Servo_PROGRAM_Run(Servo_Prg_tmp, 1);

  server.send(200, "text/html", "(m0, m1)=(" + m0 + "," + m1 + ")");
}

// --------------------------------------------------------------------------------



// WebServer
// --------------------------------------------------------------------------------

void enableWebServer()
{
  HTTPMethod getMethod = HTTP_GET;

  //server.on("/controller", getMethod, handleController);
  server.on("/save", getMethod, handleSave);
  server.on("/", getMethod, handleIndex);
  server.on("/editor", getMethod, handleEditor);
  server.on("/zero", getMethod, handleZero);
  server.on("/setting", getMethod, handleSetting);
  server.on("/online", getMethod, handleOnLine);

  server.begin();
}

// --------------------------------------------------------------------------------

// -------------------------------------------------------------------------------- Dibop 
#define MAX_MSG_LEN (128)
char message[MAX_MSG_LEN+1];

void callback(char* topic, byte* payload, unsigned int length)
{
  //copy payload to a static string  
  if (length > MAX_MSG_LEN) {
    length = MAX_MSG_LEN;
  }  
  strncpy(message, (char *)payload, length);
  message[length] = '\0';
  Servo_PROGRAM = atol(message);  
}
// -------------------------------------------------------------------------------- Dibop - FIM


// Setup
// --------------------------------------------------------------------------------

void setup(void)
{
  Serial.begin(9600);
  Serial.println("Q1 mini Start!");

  // Software PWM PIN
  GPIO14SERVO.attach(15, SERVOMIN, SERVOMAX);
  GPIO12SERVO.attach(13, SERVOMIN, SERVOMAX);
  GPIO13SERVO.attach(12, SERVOMIN, SERVOMAX);
  GPIO15SERVO.attach(14, SERVOMIN, SERVOMAX);
  GPIO16SERVO.attach(2, SERVOMIN, SERVOMAX);
  GPIO5SERVO.attach(4, SERVOMIN, SERVOMAX);
  GPIO4SERVO.attach(5, SERVOMIN, SERVOMAX);
  GPIO2SERVO.attach(16, SERVOMIN, SERVOMAX);
  
  // EEPROM
  EEPROM.begin(512);
  delay(10);

  // 清除備份目前馬達數值
  for (int Index = 0; Index < ALLMATRIX; Index++) {
    Running_Servo_POS[Index] = Servo_Act_0[Index];
  }

  // 自動歸零 增加組裝便利性
  Servo_PROGRAM_Zero();

  // -------------------------------------------------------------------------------- Dibop 
  conectarWifi();
  client.setServer(mqtt_Broker, 1883);
  client.setCallback(callback);  
  // -------------------------------------------------------------------------------- Dibop - FIM
}


// Loop
// --------------------------------------------------------------------------------

void loop(void) // obs: se Servo_PROGRAM > 0 na declaração ele não entra no loop
{
  // ---------------------------------------------------------------------- Dibop
  if(!client.connected()) {
    reconectarMQTT();
  }
  client.loop();
  
  client.subscribe(topicoController);
        
  if(Servo_PROGRAM>=1){
    switch (Servo_PROGRAM) {
      case 1: // Standby 待機
        Servo_PROGRAM_Run(Servo_Prg_1, Servo_Prg_1_Step);
        break;
      case 2: // Forward 前行
        Servo_PROGRAM_Run(Servo_Prg_2, Servo_Prg_2_Step);
        break;
      case 3: // Backward 退後
        Servo_PROGRAM_Run(Servo_Prg_3, Servo_Prg_3_Step);
        break;
      case 4: // Left shift 左移
        Servo_PROGRAM_Run(Servo_Prg_4, Servo_Prg_4_Step);
        break;
      case 5: // Right shift 右移
        Servo_PROGRAM_Run(Servo_Prg_5, Servo_Prg_5_Step);
        break;
      case 6: // Turn left 左轉
        Servo_PROGRAM_Run(Servo_Prg_6, Servo_Prg_6_Step);
        break;
      case 7: // Turn right 右轉
        Servo_PROGRAM_Run(Servo_Prg_7, Servo_Prg_7_Step);
        break;
      case 8: // Lie 趴地
        Servo_PROGRAM_Run(Servo_Prg_8, Servo_Prg_8_Step);
        break;
      case 9: // Say Hi 打招呼
        Servo_PROGRAM_Run(Servo_Prg_9, Servo_Prg_9_Step);
        Servo_PROGRAM_Run(Servo_Prg_1, Servo_Prg_1_Step);
        break;
      case 10: // Fighting 戰鬥姿態
        Servo_PROGRAM_Run(Servo_Prg_10, Servo_Prg_10_Step);
        break;
      case 11: // Push up 掌上壓
        Servo_PROGRAM_Run(Servo_Prg_11, Servo_Prg_11_Step);
        break;
      case 12: // Sleep 睡眠姿勢
        Servo_PROGRAM_Run(Servo_Prg_1, Servo_Prg_1_Step);
        Servo_PROGRAM_Run(Servo_Prg_12, Servo_Prg_12_Step);
        break;
      case 13: // 舞步 1
        Servo_PROGRAM_Run(Servo_Prg_13, Servo_Prg_13_Step);
        break;
      case 14: // 舞步 2
        Servo_PROGRAM_Run(Servo_Prg_14, Servo_Prg_14_Step);
        break;
      case 15: // 舞步 3
        Servo_PROGRAM_Run(Servo_Prg_15, Servo_Prg_15_Step);
        break;
      case 99: // 待機
        Servo_PROGRAM_Center();
        delay(300);
        break;
      case 100: // 歸零姿勢
        Servo_PROGRAM_Zero();
        delay(300);
        break;
    }
    Servo_PROGRAM = 0;
  } 
}//fim void

// -------------------------------------------------------------------------------- 
