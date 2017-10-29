
import java.util.Arrays;

private final int[] MILLIS_PER_POINT = {10, 15, 20, 30, 50, 75, 100, 150, 200, 250, 500, 750, 1000};

public final int POINT_SIZE = 5;
public final int NUM_DECAYING_POINTS = 100;

public final color COLOUR_PANEL = color(191, 206, 255);
public final color COLOUR_TEXT = color(0);

public final color COLOUR_BACKGROUND = color(126, 157, 255);
public final color COLOUR_BORDER = color(0);
public final color COLOUR_CIRCLE = color(255, 192, 0);
public final color COLOUR_CIRCLE_FILL = color(255, 229, 152);

private int iMillisPerPoint;
private int millisPerPoint;

private int numCircle;
private int numTotal;

private int millisAtLastAddition;
private boolean isPlaying;

private float[] pointX;
private float[] pointY;
private int iNext;

void setup()
{
  size(1080, 720);
  
  colorMode(HSB, 360, 100, 100);
  strokeWeight(POINT_SIZE);
  textAlign(LEFT, TOP);
  textSize(16);
  
  setIMillisPerPoint(6);
  resetPoints();
}

void draw()
{
  fill(COLOUR_PANEL);
  noStroke();
  
  rect(0, 0, 360, 720);
  
  
  fill(COLOUR_TEXT);
  
  text("Points...", 20, 20);
  text("In Circle: " + numCircle, 20, 40);
  text("Total: " + numTotal, 20, 60);
  
  text("Probability: " + (float) numCircle / numTotal, 20, 100);
  text("pi / 4 = " + PI / 4, 20, 120);
  
  text("Approximation of pi: " + 4.0 * numCircle / numTotal, 20, 160);
  text("pi: " + PI, 20, 180);
  
  text("Millis per Point: " + millisPerPoint, 20, 220);
  
  text("<space> - Start / Stop\nR - Reset\n< / > - Millis per Point\nESC - Exit", 20, 260);
  
  
  noFill();
  stroke(COLOUR_CIRCLE);
  
  ellipse(720, 360, 720, 720);
  
  
  stroke(COLOUR_BORDER);
  
  rect(360, 0, 720, 720);
  
  
  if (isPlaying && (millis() - millisAtLastAddition) > millisPerPoint)
  {
    addPoint();
    millisAtLastAddition = millis();
  }
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
        stopPoints();
      else
        startPoints();
  }
  else if (key == 'r' || key == 'R')
  {
    resetPoints();
  }
  else if (keyCode == LEFT)
  {
    setIMillisPerPoint(iMillisPerPoint - 1);
  }
  else if (keyCode == RIGHT)
  {
    setIMillisPerPoint(iMillisPerPoint + 1);
  }
}

void setIMillisPerPoint(int newIMillisPerPoint) {
  iMillisPerPoint = constrain(newIMillisPerPoint, 0, MILLIS_PER_POINT.length - 1);
  millisPerPoint = MILLIS_PER_POINT[iMillisPerPoint];
}

void startPoints()
{
  millisAtLastAddition = millis();
  isPlaying = true;
}

void stopPoints()
{
  millisAtLastAddition = millis();
  isPlaying = false;
}

void resetPoints()
{
  numCircle = 0;
  numTotal = 0;
  
  stopPoints();
  
  pointX = new float[NUM_DECAYING_POINTS];
  pointY = new float[NUM_DECAYING_POINTS];
  Arrays.fill(pointX, -1);
  Arrays.fill(pointY, -1);
  iNext = 0;
  
  background(COLOUR_BACKGROUND);
  
  fill(COLOUR_CIRCLE_FILL);
  noStroke();
  
  ellipse(720, 360, 720, 720);
}

void addPoint()
{
  noStroke();
  
  if (pointX[iNext] != -1)
  {
    fill(getColour(1));
    ellipse(pointX[iNext], pointY[iNext], POINT_SIZE, POINT_SIZE);
  }
  
  pointX[iNext] = random(360, width);
  pointY[iNext] = random(height);
  
  float iPoint = 0;
  
  for (int i = iNext; i >= 0; i--, iPoint++)
  {
    fill(getColour(iPoint / NUM_DECAYING_POINTS));
    ellipse(pointX[i], pointY[i], POINT_SIZE, POINT_SIZE);
  }
  
  for (int i = NUM_DECAYING_POINTS - 1; i > iNext; i--, iPoint++)
  {
    fill(getColour(iPoint / NUM_DECAYING_POINTS));
    ellipse(pointX[i], pointY[i], POINT_SIZE, POINT_SIZE);
  }
  
  numTotal++;
  if (dist(pointX[iNext], pointY[iNext], 720, 360) < 360)
    numCircle++;
  
  iNext = (iNext + 1) % NUM_DECAYING_POINTS;
}

color getColour(float decay)
{
  return color(0, lerp(100, 20, decay), 100);
}