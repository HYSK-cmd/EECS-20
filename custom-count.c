// custom-count.c - Lab/Programming Assignment 4 - "Countdown" C Program
// Hoon Yang
// 15 Nov, 2024

#include <stdio.h>
#include <stdlib.h>

int main(void){
    // Declaring variables
    char char_start, char_end;
    int ascii_Diff;

    // Read the starting character
    printf("Enter a starting character: ");
    scanf(" %c", &char_start);

    // Read the ending character
    printf("Enter an ending character: ");
    scanf(" %c", &char_end);

    // Calculate the ASCII difference (size)
    ascii_Diff = abs(char_start - char_end);

    // Check if the starting character is larger than the ending character in ASCII value
    if (char_start > char_end){
        for(int i = 0; i < ascii_Diff + 1; i++){
            printf("%c", char_start);
            if(i < ascii_Diff){
                printf(", ");
            }
            char_start--;
        }
    // Check if the starting character is smaller than the ending character in ASCII value
    } else if (char_start < char_end){
        for(int i = 0; i < ascii_Diff + 1; i++){
            printf("%c", char_start);
            if(i < ascii_Diff){
                printf(", ");
            }
            char_start++;
        }
    // Check if the starting character is the same as the ending character in ASCII value
    } else if (char_start == char_end){
        printf("%c\n", char_start);
    }
    return 0;
}