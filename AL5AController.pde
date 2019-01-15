// Need G4P library
import g4p_controls.*;
import processing.serial.*;

Serial myPort;
String s="";
PImage crciberneticalogo;

float A = 95.25; //millimeters
float B = 107.95;
float rtod = 57.295779;

PrintWriter output;

String fileName;
String selected_file;
int selectedfilecount=0;

boolean PLAYBACK = false;
boolean RECORD = false;
int playback_count = 0;
long previousMillis = 0;
long previousBlinkMillis = 0;
long interval = 100;
int val;

String inputString = "";
String idString = "";
String commandString = "";
boolean stringComplete = false;
String nullPort[]={"Nulo"};

public void setup() {
  size(550, 500, JAVA2D);
  createGUI();
  crciberneticalogo = loadImage("CRCibernetica509x81.png");
  String portName = Serial.list()[Serial.list().length-1];
  println("Port: " + portName);
  myPort = new Serial(this, portName, 57600);
  myPort.bufferUntil('\n');
  dropList1.setItems(Serial.list(), Serial.list().length-1);
  //dropList1.setItems(nullPort, 0);
  //fileName = getDateTime();
  //output = createWriter("data/" + "positions" + fileName + ".csv");
  //output.println("x,y,z,g,wa,wr");
}

public void draw() {
  background(255);
  image(crciberneticalogo, 20, 420, width/2, height/10 );

  updatePlayBack();
  updateAnimation();
}

/* arm positioning routine utilizing inverse kinematics */
/* z is base angle, y vertical distance from base, x is horizontal distance.*/
int Arm(float x, float y, float z, int g, float wa, int wr)
{
  float M = sqrt((y*y)+(x*x));
  if (M <= 0)
    return 1;
  float A1 = atan(y/x);
  float A2 = acos((A*A-B*B+M*M)/((A*2)*M));
  float Elbow = acos((A*A+B*B-M*M)/((A*2)*B));
  float Shoulder = A1 + A2;
  Elbow = Elbow * rtod;
  Shoulder = Shoulder * rtod;
  while ( (int)Elbow <= 0 || (int)Shoulder <= 0)
    return 1;
  //float Wris = abs(wa - Elbow - Shoulder) - 90;
  float Wris = abs(wa - Elbow - Shoulder);
  //slider1.setValue(z);
  slider2.setValue(Shoulder);
  slider3.setValue(180-Elbow);
  slider4.setValue(180-Wris);
  //slider5.setValue(g); // gripper is controller separately in this mode
  return 0;
}

void keyPressed() {
  if (keyCode==47) {// forward slash
    PLAYBACK = false;
    playback_count = 0;
    selectedfilecount=selectedfilecount+1;
    if (selectedfilecount>1) {
      selectedfilecount=1;
    }
    selected_file=selectedfilecount+".csv";
    PLAYBACK=true;
  }

  if (keyCode==83) { // s to save coordinates to file
    println("Coordinates saved to file");
    float x = slider2d1.getValueXI();
    float y = slider2d1.getValueYI();
    float z = slider1.getValueI();
    int g = slider5.getValueI();
    float w = slider6.getValueI();
    output.println(x + "," + y + "," + z + "," + g + "," + w + "," + 90);
  }
  if (keyCode==88) { // x to save and close file
    println("Close file");
    RECORD=false;
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    //exit(); // Stops the program
  }
  if (keyCode==80) { // p for playback
    println("Playback");
    PLAYBACK = true;
  }
  if (keyCode==78) { // n for new file (positions<datetime>.csv)
    fileName = getDateTime();
    output = createWriter("data/" + "positions" + fileName + ".csv");
    output.println("x,y,z,g,wa,wr");
    println("New position file");
  }
  if (keyCode==79) { // o for open file for playback
    println("Open File for Playback");
    selectInput("Select a file to playback:", "fileSelected");
  }
  if (keyCode==82) { // r for record
    println("Record");
    RECORD = true;
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    selected_file = selection.getAbsolutePath();
  }
}

String getDateTime() {
  int d = day();  
  int m = month(); 
  int y = year();  
  int h = hour();
  int min = minute();
  String s = String.valueOf(y);
  s = s + String.valueOf(m);
  s = s + String.valueOf(d);
  s = s + String.valueOf(h);
  s = s + String.valueOf(min);
  return s;
}

int ArmPlayBack(float x, float y, float z, int g, float wa, int wr)
{
  float M = sqrt((y*y)+(x*x));
  if (M <= 0)
    return 1;
  float A1 = atan(y/x);
  float A2 = acos((A*A-B*B+M*M)/((A*2)*M));
  float Elbow = acos((A*A+B*B-M*M)/((A*2)*B));
  float Shoulder = A1 + A2;
  Elbow = Elbow * rtod;
  Shoulder = Shoulder * rtod;
  while ( (int)Elbow <= 0 || (int)Shoulder <= 0)
    return 1;
  //float Wris = abs(wa - Elbow - Shoulder) - 90;
  float Wris = abs(wa - Elbow - Shoulder);
  slider1.setValue(z);
  slider2.setValue(Shoulder);
  slider3.setValue(180-Elbow);
  slider4.setValue(180-Wris);
  slider5.setValue(g);
  return 0;
}

void saveCoordinates() {
  float x = slider2d1.getValueXI();
  float y = slider2d1.getValueYI();
  float z = slider1.getValueI();
  int g = slider5.getValueI();
  float w = slider6.getValueI();
  output.println(x + "," + y + "," + z + "," + g + "," + w + "," + 90);
}
