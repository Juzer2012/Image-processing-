#include <AFMotor.h> //import your motor shield library 
AF_DCMotor motor1(1,MOTOR12_8KHZ); // set up motors.
AF_DCMotor motor2(2, MOTOR12_8KHZ);

const int ledpin=13;int recValue;

void setup()

{
  Serial.begin(9600);

  pinMode(13, OUTPUT);
  motor1.setSpeed(150); //set the speed of the motors, between 0-255
  motor2.setSpeed(150); 
}

void loop()

{
  if(Serial.available()>0)
 {

  recValue=Serial.read();

if (recValue == 100) // If use will send value 100 from MATLAB then LED will turn ON

  { digitalWrite(ledpin, HIGH);
    motor1.run(RELEASE);
    motor2.run(RELEASE);
    }

if(recValue == 101) // If use will send value 101 from MATLAB then LED will turn OFF

  { digitalWrite(ledpin, LOW);
    motor1.run(FORWARD);
    motor2.run(FORWARD);
    }

 }

}
