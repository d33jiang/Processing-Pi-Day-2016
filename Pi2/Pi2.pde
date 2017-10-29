
import java.util.Arrays;

private final int[] MILLIS_PER_PIN = {10, 15, 20, 30, 50, 75, 100, 150, 200, 250, 500, 750, 1000};

public final int LENGTH = 720 / 6;

public final float MIN_X = 360 + LENGTH;
public final float MAX_X = 1080 - LENGTH;
public final float MIN_Y = 3 * LENGTH / 2;
public final float MAX_Y = 720 - MIN_Y;

public final int LINE_SIZE = 5;
public final int NUM_DECAYING_PINS = 100;

public final color COLOUR_PANEL = color(191, 206, 255);
public final color COLOUR_TEXT = color(0);

public final color COLOUR_BACKGROUND = color(126, 157, 255);
public final color COLOUR_BORDER = color(0);
public final color COLOUR_LINES = color(0);

private int iMillisPerPin;
private int millisPerPin;

private int numAcross;
private int numTotal;

private int millisAtLastAddition;
private boolean isPlaying;

private float[] pointX;
private float[] pointY;
private boolean[] isAcross;
private int iNext;

void setup()
{
  size(1080, 720);
  
  colorMode(HSB, 360, 100, 100);
  strokeWeight(LINE_SIZE);
  textAlign(LEFT, TOP);
  textSize(16);
  
  setIMillisPerPoint(6);
  resetPins();
}

void draw()
{
  fill(COLOUR_PANEL);
  noStroke();
  
  rect(0, 0, 360, 720);
  
  
  fill(COLOUR_TEXT);
  
  text("Pins...", 20, 20);
  text("Across Lines: " + numAcross, 20, 40);
  text("Total: " + numTotal, 20, 60);
  
  text("Probability: " + (float) numAcross / numTotal, 20, 100);
  text("2 / pi = " + 2 / PI, 20, 120);
  
  text("Approximation of pi: " + 2.0 * numTotal / numAcross, 20, 160);
  text("pi: " + PI, 20, 180);
  
  text("Millis per Pin: " + millisPerPin, 20, 220);
  
  text("<space> - Start / Stop\nR - Reset\n< / > - Millis per Pin\nESC - Exit", 20, 260);
  
  
  if (isPlaying && (millis() - millisAtLastAddition) > millisPerPin)
  {
    addPin();
    millisAtLastAddition = millis();
  }
  
  
  noFill();
  stroke(COLOUR_LINES);
  
  for (int i = 1 * LENGTH; i < 720; i += LENGTH)
    line(360, i, 1080, i);
  
  
  stroke(COLOUR_BORDER);
  
  rect(360, 0, 720, 720);
  
}

void keyReleased()
{
  if (key == ESC)
  {
    exit();
  }
  else if (key == ' ')
  {
      if (isPlaying)
        stopPins();
      else
        startPins();
  }
  else if (key == 'r' || key == 'R')
  {
    resetPins();
  }
  else if (keyCode == LEFT)
  {
    setIMillisPerPoint(iMillisPerPin - 1);
  }
  else if (keyCode == RIGHT)
  {
    setIMillisPerPoint(iMillisPerPin + 1);
  }
}

void setIMillisPerPoint(int newIMillisPerPoint) {
  iMillisPerPin = constrain(newIMillisPerPoint, 0, MILLIS_PER_PIN.length - 1);
  millisPerPin = MILLIS_PER_PIN[iMillisPerPin];
}

void startPins()
{
  millisAtLastAddition = millis();
  isPlaying = true;
}

void stopPins()
{
  millisAtLastAddition = millis();
  isPlaying = false;
}

void resetPins()
{
  numAcross = 0;
  numTotal = 0;
  
  stopPins();
  
  pointX = new float[2 * NUM_DECAYING_PINS];
  pointY = new float[2 * NUM_DECAYING_PINS];
  isAcross = new boolean[NUM_DECAYING_PINS];
  Arrays.fill(pointX, -1);
  Arrays.fill(pointY, -1);
  Arrays.fill(isAcross, false);
  iNext = 0;
  
  background(COLOUR_BACKGROUND);
}

void addPin()
{
  noFill();
  
  if (pointX[iNext] != -1)
  {
    stroke(getColour(1, isAcross[iNext / 2]));
    line(pointX[iNext], pointY[iNext], pointX[iNext + 1], pointY[iNext + 1]);
  }
  
  pointX[iNext] = random(MIN_X, MAX_X);
  pointY[iNext] = random(MIN_Y, MAX_Y);
  
  float ang = random(TWO_PI);
  pointX[iNext + 1] = pointX[iNext] + LENGTH * cos(ang);
  pointY[iNext + 1] = pointY[iNext] + LENGTH * sin(ang);
  
  numTotal++;
  if (floor(pointY[iNext] / LENGTH) != floor(pointY[iNext + 1] / LENGTH))
  {
    numAcross++;
    isAcross[iNext / 2] = true;
  }
  else
    isAcross[iNext / 2] = false;
  
  float iPoint = 0;
  
  for (int i = iNext; i >= 0; i -= 2, iPoint++)
  {
    stroke(getColour(iPoint / NUM_DECAYING_PINS, isAcross[i / 2]));
    line(pointX[i], pointY[i], pointX[i + 1], pointY[i + 1]);
  }
  
  for (int i = pointX.length - 2; i > iNext; i -= 2, iPoint++)
  {
    stroke(getColour(iPoint / NUM_DECAYING_PINS, isAcross[i / 2]));
    line(pointX[i], pointY[i], pointX[i + 1], pointY[i + 1]);
  }
  
  iNext = (iNext + 2) % pointX.length;
}

color getColour(float decay, boolean across)
{
  return color(across ? 120 : 0, lerp(100, 20, decay), 100);
}