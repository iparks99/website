/*
 * Breakout
 * for CMSC131, section 0403
 * Lecturer: Professor Pugh and Professor Yoon
 * 
 * Made by Ian Parks
 * UID: 115309708
 * iparks@terpmail.umd.edu
 * Finished on 9-11-2017
 * 
 * Referenced code from: https://processing.org/reference/
 */

import javax.swing.*; //Importing swing for JOptionPanes

Player play; //Creates a new Player object
Ball ball; //Creates a new Ball object
ArrayList<Brick> bricks; //ArrayList of the bricks
boolean timer = false; //For timing
int initTime = -1; //Stores the time that the timer is started

/*
 * Draws all the bricks in the 'bricks' arrayList.
 */
void drawBricks() {
  for (Brick b : bricks) { //For-each loop goes through the 'bricks' arrayList
    fill(b.c);
    rect(b.x, b.y, b.length, b.myHeight); //Makes a new rectangle
  }
}

/*
 * Creates all the bricks in the 'bricks' arrayList.
 */
void fillBricks() {
  Brick b = new Brick(); //Reference brick
  int margin = 10; //The gap between bricks
  int xBricks = width/(b.length + margin); //Determines the number of columns of bricks
  int yBricks = (height/3)/(b.myHeight + margin); //Determines the number of rows of bricks
  for (int cols = 0; cols < xBricks; cols++) //Loops through all the columns of bricks
    for (int rows = 0; rows < yBricks; rows++) { //Loops through all the rows of bricks
      Brick br = new Brick(); //Makes a new brick, which we will insert into the 'bricks' arrayList
      br.x = (cols * br.length) + (cols+1) * margin; //Determines the x-position of the brick
      br.y = (rows * br.myHeight) + (rows+1) * margin; //Determines the y-position of the brick
      br.c = color(random(100, 255), random(255), random(255)); //Creates a random RGB value for each brick's color
      bricks.add(br); //Adding the new brick to the 'bricks' arrayList
    }
  drawBricks(); //Draws the bricks
}

/*
 * Initializes the program.
 */
void setup() {
  size(1110, 600); //Sets the size of the canvas to be 1000px by 500px
  play = new Player(); //Initializes the player
  ball = new Ball(); //Initializes the ball
  bricks = new ArrayList<Brick>(); //Initializes the 'bricks' arrayList
  fillBricks(); //Creates the bricks
  play.x = width/2 - play.length/2; //Centers the player
  ball.resetBall(); //Resets the ball
}

/*
 * This method handles most of the graphics and is called every frame.
 */
void draw() {
  background(0); //Sets the background to black. This also cleans the canvas before each frame
  fill(255); //Sets the color used to draw shapes as white

  //Timer to display how many balls are remaining, but only for 3 seconds
  if (ball.reset) {
    if (!timer) { //If the timer hasn't been activated yet...
      initTime = millis(); //...initialize when the timer starts
      timer = true; //...activate the timer
    }
    if (millis()>initTime+3000) //3000 milliseconds = 3 seconds
      ball.reset=false; //Prevent the draw() method from doing this again
    text("You have " + ball.ballsRemaining + " ball(s) left.", width/2 - 60, height/2 - 10); //Text UI indicates remaining balls to player
  }

  rect(play.x, play.y, play.length, play.myHeight); //Draws the player's paddle
  fill(ball.c); //Sets fill to the ball's color
  rect(ball.x, ball.y, ball.length, ball.myHeight); //Draws the ball
  fill(255); //Resets fill to white

  //If the ball and player collide...
  if (Object.collide(ball, play)) {
    ball.bounce(); //...make the ball bounce
    if (Object.collideSide(ball, play)) //If the ball hits the side...
      ball.bounceSide(); //...make it bounce appropriately
  }

  //For every brick in 'bricks' arrayList...
  for (int i = 0; i<bricks.size(); i++)
    if (Object.collide(ball, bricks.get(i))) { //If the ball and the current brick in question collide...
      ball.bounce(); //...make the ball bounce
      if (Object.collideSide(ball, bricks.get(i))) //If the ball hits the side...
        ball.bounceSide(); //...make it bounce appropriately
      bricks.remove(i); //...remove the brick in question
      if (bricks.size()<=0) { //If there are no bricks remaining...
        JOptionPane.showMessageDialog(null, "You win!", "Congratulations", JOptionPane.INFORMATION_MESSAGE); //...display a message that you win
        noLoop(); //Prevents the draw() method from being called anymore
        exit(); //Terminates the program
      }
    }

  ball.update(); //Updates the ball's position
  play.update(); //Updates the player's position

  for (int i=0; i<bricks.size(); i++) { //For-loop goes through bricks arrayList.
    color c = bricks.get(i).c; //Obtains the brick's RGB value
    c = color(red(c)+1, green(c)+1, blue(c)+1); //Increments the RGB values for the brick

    //Checking to make sure the bricks aren't solid white or too dark.
    if (red(c)>=255 || red(c)<20)
      c = color(20, green(c), blue(c));
    if (green(c)>=255 || green(c)<20)
      c = color(red(c), 20, blue(c));
    if (blue(c)>=255 || blue(c)<20)
      c = color(red(c), green(c), 20);

    bricks.get(i).c = c; //Sets the brick's color
  }
  drawBricks(); //Redraws the bricks
}

/*
 * Handles events created by the keyboard where a key is pressed.
 */
void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
    case LEFT: //If the left arrow key is pressed...
      play.dx = -play.speed; //...move left
      break;
    case RIGHT: //If the right arrow key is pressed...
      play.dx = play.speed; //...move right
      break;
    }
  }
}

/*
 * Handles events created by the keyboard where a key is released.
 */
void keyReleased() {
  if (key == CODED) {
    switch(keyCode) {
    case LEFT: //If the left arrow key is released...
      if (play.dx<0) //Prevents interference with right arrow key
        play.dx += play.speed; //...Stop
      break;
    case RIGHT: //If the right arrow key is released...
      if (play.dx>0) //Prevents interference with left arrow key
        play.dx -= play.speed; //...Stop
      break;
    }
  }
}

/*
 * Object is an abstract class that is extended by other classes that behave as in-game objects. 
 */
abstract static class Object {
  float x, y, dx, dy; //Positional and velocity variables
  int length, myHeight; //Size variables
  color c; //Color of the object's fill

  /*
   * Updates the Object's position.
   */
  void update() {
    x += dx;
    y += dy;
  }

  /*
   * Detects if there is a collision between two Objects.
   * 
   * @return 'true' if there is a collision, 'false' if otherwise.
   */
  static boolean collide(Object obj1, Object obj2) {
    if (obj1.x < obj2.x + obj2.length && obj1.x + obj1.length > obj2.x) //If x-positions intersect...
      if (obj2.y < obj1.y + obj1.myHeight && obj1.y < obj2.y + obj2.myHeight) //If y-positions intersect...
        return true;
    return false;
  }

  /*
   * Detects if there is a side collision between two Objects.
   * 
   * @return 'true' if there is a collision, 'false' if otherwise.
   */
  static boolean collideSide(Object obj1, Object obj2) {
    if (obj1.x+obj1.length<=obj2.x+5 || obj1.x>=obj2.x+obj2.length-5)
      return true;
    return false;
  }
}

/*
 * The Player class houses all the code specific to the Player.
 */
class Player extends Object {
  int speed = 10; //The speed of the player

  //Constructor
  Player() {
    length = width/6;
    myHeight = 20;
  }

  /*
   * Overrides the super method of update.
   */
  void update() {
    super.update(); //Calls the super update method
    y = height-2*myHeight; //Ensures the player is at a constant y-position

    //These if-statements prevent the player from leaving the canvas
    if (x<=0)
      x = 0;
    if (x+length>=width)
      x = width-length;
  }
}

/*
 * The Ball class houses all the code specific to the Ball.
 */
class Ball extends Object {
  int magnitude = 4, ballsRemaining = 4;
  boolean reset = false;

  //Constructor
  Ball() {
    length = 15;
    myHeight = 15;
  }

  /*
   * Speeds up the ball's dx and dy.
   */
  void speedUp() {
    int speedLimit = 6; //Limits the ball's speed to 6
    float dv = random(1, 1.5); //Creates a random accelation factor to the velocity
    if (abs(dx)<speedLimit)
      dx *= dv;
    if (abs(dy)<speedLimit)
      dy *= dv;
  }

  /*
   * Makes the ball bounce, and adds a little velocity to the ball to make the game more interesting.
   */
  void bounce() {
    dy = -dy;
    speedUp();
  }

  /*
   * Makes the ball bounce, and adds a little velocity to the ball to make the game more interesting.
   */
  void bounceSide() {
    dx = -dx;
    dy = -dy; //Reverse dy to account for calling bounce() method
    speedUp();
  }

  /*
   * Resets the ball's position and velocity to the defaults.
   */
  void resetBall() {
    x = width/2; //Centers the ball's x-position
    y = 300; //Hard-coded y-position
    float theta = random(-3*PI/4, -PI/4); //Gives the ball a random direction to go. It is a cone facing downward to the player
    dx = magnitude*cos(theta); //Determines the ball's x-velocity based on its angle
    dy = -magnitude*sin(theta); //Determines the ball's y-velocity based on its angle
    ballsRemaining--; //Remove a ball from the player's stockpile
    reset = true; //Notifies other objects that this ball was recently reset
    timer = false; //Resets the timer
    if (ballsRemaining<=0) { //If there are no balls left...
      JOptionPane.showMessageDialog(null, "You lose", ":(", JOptionPane.INFORMATION_MESSAGE); //...display a message that you lose
      noLoop(); //Prevents any more drawing from the draw() method
      exit(); //Kill the program
    }
  }

  /*
   * Overrides the super method of update.
   */
  void update() {
    super.update(); //Calls the super update method
    float rgb = (millis()%1000); //Creates a value between 0 and 1000 which changes as time passes
    c = color(255*(rgb/1000), 255*(1-(rgb/1000)), 255*(rgb/1000)); //Sets the color of the ball to a new color based on the amount of time passed
    if (y>height) //If the ball falls below the bottom of the screen...
      resetBall(); //...reset the ball to its default position and velocity
    if (x <= 0 || x+length >= width) //If the ball hits the walls...
      dx = -dx; //...bounce (w/o adding any additional velocity)
    if (y <= 0) //If the ball hits the ceiling...
      dy = -dy; //...bounce (w/o adding any additional velocity)
  }
}

/*
 * The Brick class houses all the code specific to the Bricks.
 */
class Brick extends Object {
  //Constructor
  Brick() {
    length = 100;
    myHeight = 30;
  }
}