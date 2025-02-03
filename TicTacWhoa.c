//EECS 20
//NAME: HOON YANG
//DATE COMPLETED: NOV 29, 2024
//THIS PA WAS TOO HARD BUT I MANAGED TO COMPLETE IT
#include <stdio.h>
#include <string.h>
//By default, the first and second row have underscores and the last row has blanks
char board[3][3] = {{' ', '_', '_'}, 
                    {' ', '_', '_'}, 
                    {' ', '_', '_'}};
//Functions
int updateBoard(char move[], char mark);
int checkWinner();
int checkDraw();
void printBoard();
void resetBoard();
//Execute Tic-Tac-Whoa program
int main() {
    int choice; //Input to start or quit a game
    int program = 1;
    while(program){
        printf("Would you like to start a game? (1=yes, 0=no): ");
        scanf("%d", &choice);
        //User exits a game
        if(choice == 0){
            printf("Bye!\n");
            printf("Exiting program.\n");
            break;
        //User chooses to play a game
        } else if(choice == 1){
            char player = 'X';
            char move[5];
            int player_num = 1;
            int game = 1;
            //Reset the board
            resetBoard();
            //Print the board
            printBoard();
            while(game){
                printf("Player %d's move: ", player_num);
                scanf("%s", move);
                //Exit program if player enters 'quit'
                if(strcmp(move, "quit") == 0){
                    printf("Player %d quits Tic-Tac-Whoa\n", player_num);
                    printf("Halting program...\n");
                    program = 0;
                    break;
                }
                //Update the board and check the sameMove at the same time
                int sameMove = updateBoard(move, player);
                printBoard();
                //If move is already entered
                if(sameMove != 1) continue;
                //Check the winner
                //If return value from checkWinner function is 1 then there's a winner
                //Go back to the menu
                if(checkWinner()){
                    printf("Player%d is a winner. Congratulations!\n", player_num);
                    game = 0;
                    break;
                }
                //Check if it's a draw
                //Go back to the menu
                if(checkDraw()){
                    printf("It is a draw :(\n");
                    game = 0;
                    break;
                }
                //Switch the player
                if(player_num == 1) player_num = 2;
                else player_num = 1;
                //Switch the mark
                if(player == 'X') player = 'O';
                else player = 'X';
            }
        } else {
            //User puts an invalid input
            printf("Invalid choice. Please enter a valid choice again.\n");
        }
    }
}
//update the board
int updateBoard(char move[], char mark){
    int row = move[1] - '1';  //Convert the row into a corresponding index (3 = 2, 2 = 1, 1 = 0)
    int col = move[0] - 'A';  //Convert the column into a corresponding index (A = 0, B = 1, C = 2)
    //Check the length if it's exactly 2; otherwise invalid move
    if(strlen(move)!= 2){
        printf("Invalid move, please specify both column and row.\n");
        return 0;
    }
    //Replace either a blank or underscore with a corresponding mark
    if(row >= 0 && row <= 2 && col >= 0 && col <= 2){
        //Prompts a message to tell user that the move is already selected
        if(board[col][row] == 'X' || board[col][row] == 'O'){
            printf("\nAlready entered, please choose a different move.\n");
            printf("\n");
            return 0;
        }
        if(board[col][row] == ' ' || board[col][row] == '_'){
            board[col][row] = mark;
            return 1;
        }
    } else {
        //User puts an invalid move
        printf("Invalid move, please specify both column and row.\n");
        return 0;
    }
    return 0;
}
//Print out the board
void printBoard(){
    printf("3 _%c_|_%c_|_%c_\n", board[0][2], board[1][2], board[2][2]);
    printf("2 _%c_|_%c_|_%c_\n", board[0][1], board[1][1], board[2][1]);
    printf("1  %c | %c | %c \n", board[0][0], board[1][0], board[2][0]);
    printf("   A   B   C     \n");
}
//Reset the board
void resetBoard(){
    for(int i = 0; i < 3; i++){
        for(int j = 0; j < 3; j++){
            if(j > 0){
                board[i][j] = '_';
            } else {
                board[i][j] = ' ';
            }
        }
    }
}
//Check winner
int checkWinner(){
    for(int i = 0; i < 3; i++){
        //Check rows
        if(board[0][i] != ' ' && board[0][i] != '_'){
            if(board[0][i] == board[1][i] && board[1][i] == board[2][i]){
                return 1;
            }
        }
        //Check columns
        if(board[i][0] != ' ' && board[i][0] != '_'){
            if(board[i][0] == board[i][1] && board[i][1] == board[i][2]){
                return 1;
            }
        }
    }
    //Check diagonals
    if(board[0][0] != ' ' && board[0][0] != '_'){
        if(board[0][0] == board[1][1] && board[1][1] == board[2][2]){
            return 1;
        }
    }
    if(board[0][2] != ' ' && board[0][2] != '_'){
        if(board[0][2] == board[1][1] && board[1][1] == board[2][0]){
            return 1;
        }
    }
    return 0;
}
//Check if it's a draw
int checkDraw(){
    for(int i = 0; i < 3; i++){
        for(int j = 0; j < 3; j++){
            if(board[i][j] == '_' || board[i][j] == ' '){
                return 0; //Board is not full
            }
        }
    }
    return 1; //Board is full
}
//EOF