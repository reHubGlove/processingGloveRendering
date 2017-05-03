import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

boolean start=false;
boolean data=false;

void setup() {
  //size(800, 800, P3D);
  fullScreen(P3D);
  oscP5 = new OscP5(this,12000); // Start Listening on port 12000
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  xPosTot = (width+1);
  
  graphX        = new int[xPosTot];
  graphY        = new int[xPosTot];
  graphZ        = new int[xPosTot];
  graphThumb    = new int[xPosTot];
  graphThumbrol = new int[xPosTot];
  graphIndex    = new int[xPosTot];
  graphMiddle   = new int[xPosTot];
  graphRing     = new int[xPosTot];
  graphLittle   = new int[xPosTot];
}

/*** Offset *****************************************************************/

float rotxoffset   = 0; //x offset factor
float rotyoffset   = 0; //y offset factor
float rotzoffset   = 0; //z offset factor

int offThumb       = 0;
int offThumbrol    = 0;
int offIndex       = 0;
int offMiddle      = 0;
int offRing        = 0;
int offLittle      = 0;

int offPadThumb    = 0;
int offPadIndex    = 0;
int offPadMiddle   = 0;
int offPadRing     = 0;
int offPadLittle   = 0;

/***************************************************************************/

int rotxfactor = 0; //x rotation factor controlled by up/down arrows
int rotyfactor = 0; //y rotation factor controlled by up/down arrows
int rotzfactor = 0; //z rotation factor controlled by up/down arrows
int rotThumb, rotThumbrol, rotIndex, rotMiddle, rotRing, rotLittle;
int padThumb,padIndex,padMiddle,padRing,padLittle;

/***************************************************************************/

float rotx = 0;
float roty = 0;
float rotz = 0;

int xPos = 0;
int xPosTot = 1441;

int[] graphX        = new int[xPosTot];
int[] graphY        = new int[xPosTot];
int[] graphZ        = new int[xPosTot];
int[] graphThumb    = new int[xPosTot];
int[] graphThumbrol = new int[xPosTot];
int[] graphIndex    = new int[xPosTot];
int[] graphMiddle   = new int[xPosTot];
int[] graphRing     = new int[xPosTot];
int[] graphLittle   = new int[xPosTot];

boolean gXview        = false;
boolean gYview        = false;
boolean gZview        = false;
boolean gThumbview    = false;
boolean gThumbrolview = false;
boolean gIndexview    = false;
boolean gMiddleview   = false;
boolean gRingview     = false;
boolean gLittleview   = false;

String handMode = "cube";
/***************************************************************************/

void draw() {
  if (mousePressed == true) { 
    rotx = (mouseY/float(width))*-2*PI+PI;
    roty = (mouseX/float(height))*2*PI-PI;
  } else {
    rotx = rotxfactor*PI/180;
    roty = rotyfactor*PI/180;
  }
  rotz = rotzfactor*PI/180;
  
  if (start) {
    writeText();
    drawCircles();
    
    translate(width/2, (height/2)+100);           // center drawing start point in screen
    drawHand();                                   // Palmo; cube/wire
    drawDito(76,0,-150,rotIndex/2.7,180,true);    // Indice
    drawDito(24,0,-153,rotMiddle/2.7,200,true);   // Medio
    drawDito(-28,0,-150,rotRing/2.7,180,true);    // Anulare
    drawDito(-80,0,-145,rotLittle/2.7,150,true);  // Mignolo
    
    // Pollice
    translate(50,-20,100);
    rotateZ(rotThumbrol*(PI/180));                // rotazione
    translate(-50,20,-100);

    translate(140,0,20);
    rotateY(-45*(PI/180)); rotateZ(-130*(PI/180)); // posizione
    drawDito(0,0,0,-(rotThumb/3.7),180,false); // Pollice
    
  } else {
    waitSetting();
  }
}

void drawDito(float x, float y, float z, float angle, float totlen, boolean thirdPhalanx) {

  // print(" Ang: "); print( angle ); print(" Len: "); print( totlen );
  
  translate(x,y,0); // posiziona la falange in X e Y lasciano Z controllato in seguito
  
  float len = (totlen/3)-3;
  float ang = (angle*(PI/180));
  
  float T1 = (z+(len/2)+18);
  float T2 = (z-len-18);
  float T3 = (z-(2*len)-28);
  
  /*************************************/
  
  stroke(255, 0, 0);
  translate(0,0,T1);
  sphere(15);                            // Prima sfera
  rotateX(ang);
  translate(0,0,-T1);
  
  /*************************************/
  
  translate(0,0,z);
  strokeWeight(2);
  drawCylinder(180,15,len,255,0,0);      // Prima falange
  translate(0,0,-(len/2));
  sphere(15);                            // Seconda sfera
  rotateX(ang);
  translate(0,0,(len/2));
  translate(0,0,-z);
  
  /*************************************/
  
  translate(0,0,T2);
  strokeWeight(2);
  drawCylinder(180,15,len,0,255,0);      // Seconda falange
  translate(0,0,-(len/2));
  sphere(15);                            // Terza sfera
  rotateX(ang);
  translate(0,0,(len/2));
  translate(0,0,-T2);
  
  /*************************************/
  
  if (thirdPhalanx) {
    translate(0,0,T3);
    strokeWeight(2);
    drawCylinder(180,15,(len-20),0,0,255);// Terza falange
    translate(0,0,-((len-20)/2));
    sphere(15);                           // Quarta sfera, polpastrello
    translate(0,0,((len-20)/2));
    translate(0,0,-T3);
  }
  
  /*************************************/
  
  translate(0,0,T2);
  translate(0,0,-(len/2));
  rotateX(-ang);
  translate(0,0,(len/2));
  translate(0,0,-T2);
  
  /*************************************/
  
  translate(0,0,z);
  translate(0,0,-(len/2));
  rotateX(-ang);
  translate(0,0,(len/2));
  translate(0,0,-z);
  
  /*************************************/
  
  translate(0,0,T1);
  rotateX(-ang);
  translate(0,0,-T1);
  
  /*************************************/
  
  translate(-x,-y,0); // annulla la posizione X e Y lasciano Z dove fissato dal disegno precedente
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT)     { rotyfactor += 10; }
    else if (keyCode == LEFT) { rotyfactor -= 10; }
    
    if (keyCode == UP)        { rotxfactor += 10; }
    else if (keyCode == DOWN) { rotxfactor -=  10; }
    
    if (keyCode == ALT)          { rotzfactor += 10; }
    else if (keyCode == CONTROL) { rotzfactor -= 10; }
  }
  
  if ((key == 'z' || key == 'Z') && rotIndex < 230 )    { rotIndex+= 10; }
  if ((key == 'a' || key == 'A') && rotIndex > 0 )      { rotIndex -= 10; }
  if ((key == 'x' || key == 'X') && rotMiddle < 230 )   { rotMiddle += 10; }
  if ((key == 's' || key == 'S') && rotMiddle > 0 )     { rotMiddle -= 10; }
  if ((key == 'c' || key == 'C') && rotRing < 230 )     { rotRing += 10; }
  if ((key == 'd' || key == 'D') && rotRing > 0 )       { rotRing -= 10; }
  if ((key == 'v' || key == 'V') && rotLittle < 230 )   { rotLittle += 10; }
  if ((key == 'f' || key == 'F') && rotLittle > 0 )     { rotLittle -= 10; }
  
  if ((key == 'b' || key == 'B') && rotThumb < 230 )    { rotThumb += 10; }
  if ((key == 'g' || key == 'G') && rotThumb > 0 )      { rotThumb -= 10; }
  
  if ((key == 'm' || key == 'M') && rotThumbrol < 30 )  { rotThumbrol += 5; }
  if ((key == 'j' || key == 'J') && rotThumbrol > 0 )   { rotThumbrol -= 5; }
  
  if ((key == '1') && padThumb < 40 )  { padThumb += 5; }
  if ((key == '2') && padThumb > 0 )    { padThumb -= 5; }
  
  if ((key == '3') && padIndex < 40 )  { padIndex += 5; }
  if ((key == '4') && padIndex > 0 )    { padIndex -= 5; }
  
  if ((key == '5') && padMiddle < 40 )  { padMiddle += 5; }
  if ((key == '6') && padMiddle > 0 )    { padMiddle -= 5; }
  
  if ((key == '7') && padRing < 40 )  { padRing += 5; }
  if ((key == '8') && padRing > 0 )    { padRing -= 5; }
  
  if ((key == '9') && padLittle < 40 )  { padLittle += 5; }
  if ((key == '0') && padLittle > 0 )    { padLittle -= 5; }
  
  if ((key == 'h' || key == 'H')) { setting(); }
  
  if ((key == 'q' || key == 'Q')) { gXview        = !gXview;        }
  if ((key == 'w' || key == 'W')) { gYview        = !gYview;        }
  if ((key == 'e' || key == 'E')) { gZview        = !gZview;        }
  if ((key == 'r' || key == 'R')) { gThumbview    = !gThumbview;    }
  if ((key == 't' || key == 'T')) { gThumbrolview = !gThumbrolview; }
  if ((key == 'y' || key == 'Y')) { gIndexview    = !gIndexview;    }
  if ((key == 'u' || key == 'U')) { gMiddleview   = !gMiddleview;   }
  if ((key == 'i' || key == 'I')) { gRingview     = !gRingview;     }
  if ((key == 'o' || key == 'O')) { gLittleview   = !gLittleview;   }
  
  if ((key == 'k' || key == 'K'))  { handMode = "cube"; }
  if ((key == 'l' || key == 'L'))  { handMode = "wire"; }
}

/***************************************************************************/

void oscEvent(OscMessage theOscMessage) {
  // print the address pattern and the typetag of the received OscMessage 
  // print("### received an osc message.");
  // print(" addrpattern: "+theOscMessage.addrPattern());
  // println(" typetag: "+theOscMessage.typetag());

  if(theOscMessage.checkAddrPattern("/leftGlove")==true) {
    rotxfactor  = theOscMessage.get(0).intValue(); //print("pi "); println(rotxfactor);
    rotyfactor  = theOscMessage.get(2).intValue(); //print("ro "); println(rotyfactor);
    rotzfactor  = theOscMessage.get(1).intValue(); //print("yo "); println(rotzfactor);
    
    rotThumb    = theOscMessage.get(3).intValue(); //print("po "); println(rotThumb);
    rotThumbrol = theOscMessage.get(4).intValue(); //print("p2 "); println(rotThumbrol);
    rotIndex    = theOscMessage.get(5).intValue(); //print("in "); println(rotIndex);
    rotMiddle   = theOscMessage.get(6).intValue(); //print("me "); println(rotMiddle);
    rotRing     = theOscMessage.get(7).intValue(); //print("an "); println(rotRing);
    rotLittle   = theOscMessage.get(8).intValue(); //print("mi "); println(rotLittle);
    
    padThumb    = theOscMessage.get(9).intValue();  //print("ppo "); println(padThumb);
    padIndex    = theOscMessage.get(10).intValue(); //print("pin "); println(padIndex);
    padMiddle   = theOscMessage.get(11).intValue(); //print("pme "); println(padMiddle);
    padRing     = theOscMessage.get(12).intValue(); //print("pan "); println(padRing);
    padLittle   = theOscMessage.get(13).intValue(); //print("pmi "); println(padLittle);
  }
}

/***************************************************************************/

void waitSetting() {
  int v_space = 110;
  
  background(0);
  stroke(0,0,200);
  line (0,70,width,70); // monitor bar
  fill(255);
  textSize(20);
  text ("Place your hand horizontally and press H",50,40);
  
  textSize(30);
  text ("Help",50,110);
  
  textSize(15);
  v_space += 40;
  text ("[h or H]",50,v_space);
  text ("show/hide this help",120,v_space);
  v_space += 20;
  text ("[q or Q]",50,v_space);
  text ("show/hide X graph on grid",120,v_space);
  v_space += 20;
  text ("[w or W]",50,v_space);
  text ("show/hide Y graph on grid",120,v_space);
  v_space += 20;
  text ("[e or E]",50,v_space);
  text ("show/hide Z graph on grid",120,v_space);
  v_space += 20;
  text ("[r or R]",50,v_space);
  text ("show/hide Thumb graph on grid",120,v_space);
  v_space += 20;
  text ("[t or T]",50,v_space);
  text ("show/hide Thumb Rotation graph on grid",120,v_space);
  v_space += 20;
  text ("[y or Y]",50,v_space);
  text ("show/hide Index graph on grid",120,v_space);
  v_space += 20;
  text ("[u or U]",50,v_space);
  text ("show/hide Middle graph on grid",120,v_space);
  v_space += 20;
  text ("[i or I]",50,v_space);
  text ("show/hide Ring graph on grid",120,v_space);
  v_space += 20;
  text ("[o or O]",50,v_space);
  text ("show/hide Little graph on grid",120,v_space);
}

/***************************************************************************/

void setting() {
  rotxoffset = rotxfactor*PI/180;
  rotyoffset = rotyfactor*PI/180;
  rotzoffset = rotzfactor*PI/180;
  
  offThumb     = rotThumb;
  offThumbrol  = rotThumbrol;
  offIndex     = rotIndex;
  offMiddle    = rotMiddle;
  offRing      = rotRing;
  offLittle    = rotLittle;
  
  offPadThumb  = padThumb;
  offPadIndex  = padIndex;
  offPadMiddle = padMiddle;
  offPadRing   = padRing;
  offPadLittle = padLittle;
  
  start = !start;
  
  for (int i=0; i<=width; i++) {
      graphX[i]       = 100;
      graphY[i]       = 100;
      graphZ[i]       = 100;
      graphThumb[i]   = 200;
      graphThumbrol[i]= 200;
      graphIndex[i]   = 200;
      graphMiddle[i]  = 200;
      graphRing[i]    = 200;
      graphLittle[i]  = 200;
  }
}

/***************************************************************************/

void writeText() {
  background(0);
  stroke(0, 0, 200);
  
  int gridBarX = 0;
  int gridBarY = 200;
  
  if (data) {
    line (0,70,width,70); // first monitor bar
    fill(255);
    textSize(15);
    text (" rotateX: " + rotx +" pi ", 0,15);
    text (" rotateY: " + roty +" pi ", 0,40);
    text (" rotateZ: " + rotz +" pi ", 0,65);
    
    text (" rotPollice: " + rotThumb, 300,15);
    text (" rotPollRol:  " + rotThumbrol, 300,40);
    text (" rotIndice:   " + rotIndex, 300,65);
    
    text (" rotMedio:   " + rotMiddle, 600,15);
    text (" rotAnulare: " + rotRing, 600,40);
    text (" rotMignolo: " + rotLittle, 600,65);
    
    /*
    text (" rotPollice: " + padThumb, 300,15);
    text (" rotPollRol:  " + padIndex, 300,40);
    text (" rotIndice:   " + padMiddle, 300,65);
    
    text (" rotMedio:   " + padRing, 600,15);
    text (" rotAnulare: " + padLittle, 600,40);
    */
    gridBarX = 70;
    gridBarY = 200; 
  }
  fill(0, 0, 200);
  gridBar(gridBarX,gridBarY);
  
  /******* Graph *******/
  
  graphX[xPos]       = int(map(rotxfactor,  0, 165, gridBarY/2, gridBarX));
  graphY[xPos]       = int(map(rotyfactor,  0, 165, gridBarY/2, gridBarX));
  graphZ[xPos]       = int(map(rotzfactor,  0, 165, gridBarY/2, gridBarX));
  graphThumb[xPos]   = int(map(rotThumb,    0, 230, gridBarY,   gridBarX));
  graphThumbrol[xPos]= int(map(rotThumbrol, 0, 230, gridBarY,   gridBarX));
  graphIndex[xPos]   = int(map(rotIndex,    0, 230, gridBarY,   gridBarX));
  graphMiddle[xPos]  = int(map(rotMiddle,   0, 230, gridBarY,   gridBarX));
  graphRing[xPos]    = int(map(rotRing,     0, 230, gridBarY,   gridBarX));
  graphLittle[xPos]  = int(map(rotLittle,   0, 230, gridBarY,   gridBarX));
  
  if (xPos >=width) { 
    graphX[(xPos-1)]       = 0;
    graphY[(xPos-1)]       = 0;
    graphZ[(xPos-1)]       = 0;
    graphThumb[(xPos-1)]   = 0;
    graphThumbrol[(xPos-1)]= 0;
    graphIndex[(xPos-1)]   = 0;
    graphMiddle[(xPos-1)]  = 0;
    graphRing[(xPos-1)]    = 0;
    graphLittle[(xPos-1)]  = 0;
    
    xPos=0;
  } else { xPos++; }
  
  stroke(255);
  line(xPos,gridBarY,xPos,gridBarX);
  
  if ( gXview )        graphLine(graphX, 0,0,255);
  if ( gYview )        graphLine(graphY, 0,255,0);
  if ( gZview )        graphLine(graphZ, 255,0,0);
  if ( gThumbview )    graphLine(graphThumb, 0,255,255);
  if ( gThumbrolview ) graphLine(graphThumbrol, 0,255,255);
  if ( gIndexview )    graphLine(graphIndex, 255,255,0);
  if ( gMiddleview )   graphLine(graphMiddle, 255,255,255);
  if ( gRingview )     graphLine(graphRing, 127,255,255);
  if ( gLittleview )   graphLine(graphLittle, 127,127,255);
  
  /******* End Graph ***/

}

/***************************************************************************/

void drawHand() {
  translate(0,0,100);
  rotateX(rotx-rotxoffset);  //
  rotateY(roty-rotyoffset);  // rotate drawing coordinates according to user input variables
  rotateZ(rotz-rotzoffset);  //
  translate(0,0,-100);
  
  strokeWeight(2);
  //drawStar(100,30,100);
  
  strokeWeight(2);
  stroke(255,0,0);
  noFill();
  translate(0,0,100);
  if (handMode == "cube") { box(200,40,200); }
  if (handMode == "wire") {
    
    stroke(255);
    byte diameter = 5;
  
    rotateY(20*(PI/180));
    translate(-40,0,-10);
    drawCylinder(180,diameter,200,255,255,255);
    translate(40,0,10);
    rotateY(-20*(PI/180));
    
    rotateY(-7*(PI/180));
    translate(12.5,0,-5);
    drawCylinder(180,diameter,200,255,255,255);
    translate(-12.5,0,5);
    rotateY(7*(PI/180));
    
    rotateY(7*(PI/180));
    translate(-15,0,-5);
    drawCylinder(180,diameter,200,255,255,255);
    translate(15,0,5);
    rotateY(-7*(PI/180));
    
    rotateY(-20*(PI/180));
    translate(40,0,-10);
    drawCylinder(180,diameter,200,255,255,255);
    translate(-40,0,10);
    rotateY(20*(PI/180));
    
    translate(0,0,100);
    sphere(20);
    translate(0,0,-100);
    
    translate(50,0,80);
    rotateY(-65*(PI/180));
    drawCylinder(180,diameter,100,255,255,255);
    rotateY(65*(PI/180));
    translate(-50,0,-80);
  } 
}

/***************************************************************************/

void drawCylinder(int sides, float r, float h, int red, int green, int blue) {
    stroke(red, green, blue);
    //fill(red,green,blue);
    
    float angle = 360 / sides;
    float halfHeight = h / 2;
    // draw top shape
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, -halfHeight );    
    }
    endShape(CLOSE);
    // draw bottom shape
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight );    
    }
    endShape(CLOSE);
    
    // draw body
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight);
        vertex( x, y, -halfHeight);    
    }
    endShape(CLOSE); 
} 

/***************************************************************************/

void gridBar(int min, int max) {
   strokeWeight(1);
   stroke(127,127,127);
   int distGrid = ((max-min)/15);
   for ( int i=min; i <= max; i+=distGrid ) { line( 0,i,width,i); }
   // for ( int i=0; i <= width; i+=10 ) { line( i,min,i,max); }
}

/***************************************************************************/

void graphLine (int[] graph, int colorR, int colorG, int colorB) {
  strokeWeight(1);
  stroke( colorR,colorG,colorB );
  for (int i = 0; i < width; i++) {
    int preIndex = (i-1);
    if ( preIndex < 0 ) preIndex = 0;
    line(preIndex, graph[preIndex], i, graph[i]);
  } 
}

void drawStar(int xLen,int yLen,int zLen) {
  stroke(255, 255, 255); line(-xLen, 0, xLen, 0);       // X axis
  stroke(0, 255, 0); line(0, yLen, 0, -yLen);       // Z axis
  stroke(0, 0, 255); line(0, 0, -zLen, 0, 0, zLen); // Y axis
}

void drawCircles() {
  int Xpos = 50;
  int Ypos = 260;
  
  stroke(255, 0, 0);   fill(255, 0, 0);   ellipse(Xpos,     Ypos,padThumb, padThumb);   // Pollice
  stroke(0, 255, 0);   fill(0, 255, 0);   ellipse(Xpos+50,  Ypos,padIndex,padIndex);    // Indice
  stroke(0, 0, 255);   fill(0, 0, 255);   ellipse(Xpos+100, Ypos,padMiddle,padMiddle);  // Medio
  stroke(255, 0, 255); fill(255, 0, 255); ellipse(Xpos+150, Ypos,padRing,padRing);      // Anulare
  stroke(0, 255, 255); fill(0, 255, 255); ellipse(Xpos+200, Ypos,padLittle,padLittle);  // Mignolo
}