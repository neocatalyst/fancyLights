
import processing.serial.*;  // Import Serial library to talk to Arduino 
import ddf.minim.*;
import ddf.minim.analysis.*;


Serial myPort; 

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;

float kickSize, snareSize, hatSize;



void setDmxChannel(int channel, int value) {
  // Convert the parameters into a message of the form: 123c45w where 123 is the channel and 45 is the value
  // then send to the Arduino
  myPort.write( str(channel) + "c" + str(value) + "w" );

}
  

void setup() {
  size(512, 200, P3D);

    minim = new Minim(this);
    //make a folder called data and add the song to it 
       song = minim.loadFile("lights.mp3", 2048);

      song.play();

  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(100);  
  kickSize = snareSize = hatSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  

  
  
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);

}

void draw() {
  background(0);
  fill(255);
  if(beat.isKick()) {
 setDmxChannel(1,250);
    kickSize = 32;
  }
  if(beat.isSnare()) {
 setDmxChannel(1,150);      snareSize = 32;
  }
  if(beat.isHat()) {
 setDmxChannel(1,50);
    hatSize = 32;
  }

 setDmxChannel(1,0);
  textSize(kickSize);
  text("KICK", width/4, height/2);
  textSize(snareSize);
  text("SNARE", width/2, height/2);
  textSize(hatSize);
  text("HAT", 3*width/4, height/2);
  kickSize = constrain(kickSize * 0.95, 16, 32);
  snareSize = constrain(snareSize * 0.95, 16, 32);
  hatSize = constrain(hatSize * 0.95, 16, 32);
}

void stop() {
  // always close Minim audio classes when you are finished with them
  song.close();
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}


