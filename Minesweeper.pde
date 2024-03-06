import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public static final int NUM_ROWS = 25;
public static final int NUM_COLS = 25;
public static final int NUM_BOMBS = 40;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );
  //first call to new
  //this intializes the emptya apartment buildings across all the floors
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  //your code to initialize buttons goes here
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  for (int i = 0; i < NUM_BOMBS; i++) {
    setMines();
  }
}
public void setMines()
{
  int r = (int)(Math.random()* NUM_ROWS);
  int c = (int)(Math.random()* NUM_COLS);
  if (!mines.contains(buttons[r][c])) {
    mines.add(buttons[r][c]);
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  //your code here
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      if (mines.contains(buttons[i][j]) == false && buttons[i][j].clicked == false) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  //your code here
  for (int i = 0; i < NUM_ROWS; i++){
    for(int j = 0; j < NUM_COLS; j++){
      MSButton button = buttons[i][j];
      if (mines.contains(button)){
        button.clicked= true;
      }
    }
  }

  String lose = "You Lose";
  textAlign(CENTER, CENTER);

  for (int i = 0; i < lose.length(); i++) {
    buttons[NUM_ROWS/2][i+8].setLabel(lose.substring(i, i+1));
  }
}
public void displayWinningMessage()
{
  //your code here
  if (isWon()) {
    String win = "You Win";
  textAlign(CENTER, CENTER);

    for (int i = 0; i < win.length(); i++) {
      buttons[NUM_ROWS/2][i+9].setLabel(win.substring(i, i+1));
    }
  }
}
public boolean isValid(int r, int c)
{
  //your code here
  if (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for (int i = row-1; i <= row+1; i++) {
    for (int j = col-1; j <= col+1; j++) {
      if (isValid(i, j) && mines.contains(buttons[i][j])) {
        numMines++;
      }
    }
    if (mines.contains(buttons[row][col])) {
      numMines--;
    }
  }
  return numMines;
}

public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (mouseButton == RIGHT) {
      flagged = !flagged;
    } else if ( mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
    } else {
      for (int i = myRow - 1; i <= myRow + 1; i++) {
        for (int j = myCol - 1; j <= myCol + 1; j++) {
          if (isValid(i, j) && !buttons[i][j].clicked) {
            buttons[i][j].mousePressed();
          }
        }
      }
    
  }
}

public void draw () {    
  if (flagged)
    fill(#F0E9A0);
  else if ( clicked && mines.contains(this) ) 
    fill(255, 0, 0);
  else if (clicked)
    fill( 200 );
  else 
  fill( 100 );

  rect(x, y, width, height);
  fill(0);
  text(myLabel, x+width/2, y+height/2);
}
public void setLabel(String newLabel)
{
  myLabel = newLabel;
}
public void setLabel(int newLabel)
{
  myLabel = ""+ newLabel;
}
public boolean isFlagged()
{
  return flagged;
}
}
