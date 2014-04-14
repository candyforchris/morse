//
//  MorseCodeCharacter.m
//  Morse Code
//
//  Created by Christopher Cohen on 4/14/14.
//  Copyright (c) 2014 Christopher Cohen. All rights reserved.
//

#import "MorseCodeCharacter.h"

@implementation MorseCodeCharacter



+(instancetype)newWithChar: (unichar)character {
    
    MorseCodeCharacter *newMorseCharacter = [MorseCodeCharacter new];
    
    switch (character) {
        case 'a': case 'A':
            newMorseCharacter.dotsAndDashes = @".-";
            newMorseCharacter.morseCharacter = morseA;
            break;
        case 'b': case 'B':
            newMorseCharacter.dotsAndDashes = @"-...";
            newMorseCharacter.morseCharacter = morseB;
            break;
        case 'c': case 'C':
            newMorseCharacter.dotsAndDashes = @"-.-.";
            newMorseCharacter.morseCharacter = morseC;
            break;
        case 'd': case 'D':
            newMorseCharacter.dotsAndDashes = @"-..";
            newMorseCharacter.morseCharacter = morseD;
            break;
        case 'e': case 'E':
            newMorseCharacter.dotsAndDashes = @".";
            newMorseCharacter.morseCharacter = morseE;
            break;
        case 'f': case 'F':
            newMorseCharacter.dotsAndDashes = @"..-.";
            newMorseCharacter.morseCharacter = morseF;
            break;
        case 'g': case 'G':
            newMorseCharacter.dotsAndDashes = @"--.";
            newMorseCharacter.morseCharacter = morseG;
            break;
        case 'h': case 'H':
            newMorseCharacter.dotsAndDashes = @"....";
            newMorseCharacter.morseCharacter = morseH;
            break;
        case 'i': case 'I':
            newMorseCharacter.dotsAndDashes = @"..";
            newMorseCharacter.morseCharacter = morseI;
            break;
        case 'j': case 'J':
            newMorseCharacter.dotsAndDashes = @".---";
            newMorseCharacter.morseCharacter = morseJ;
            break;
        case 'k': case 'K':
            newMorseCharacter.dotsAndDashes = @"-.-";
            newMorseCharacter.morseCharacter = morseK;
            break;
        case 'l': case 'L':
            newMorseCharacter.dotsAndDashes = @".-..";
            newMorseCharacter.morseCharacter = morseL;
            break;
        case 'm': case 'M':
            newMorseCharacter.dotsAndDashes = @"--";
            newMorseCharacter.morseCharacter = morseM;
            break;
        case 'n': case 'N':
            newMorseCharacter.dotsAndDashes = @"-.";
            newMorseCharacter.morseCharacter = morseN;
            break;
        case 'o': case 'O':
            newMorseCharacter.dotsAndDashes = @"---";
            newMorseCharacter.morseCharacter = morseO;
            break;
        case 'p': case 'P':
            newMorseCharacter.dotsAndDashes = @".--.";
            newMorseCharacter.morseCharacter = morseP;
            break;
        case 'q': case 'Q':
            newMorseCharacter.dotsAndDashes = @"--.-";
            newMorseCharacter.morseCharacter = morseQ;
            break;
        case 'r': case 'R':
            newMorseCharacter.dotsAndDashes = @".-.";
            newMorseCharacter.morseCharacter = morseR;
            break;
        case 's': case 'S':
            newMorseCharacter.dotsAndDashes = @"...";
            newMorseCharacter.morseCharacter = morseS;
            break;
        case 't': case 'T':
            newMorseCharacter.dotsAndDashes = @"-";
            newMorseCharacter.morseCharacter = morseT;
            break;
        case 'u': case 'U':
            newMorseCharacter.dotsAndDashes = @"..-";
            newMorseCharacter.morseCharacter = morseU;
            break;
        case 'v': case 'V':
            newMorseCharacter.dotsAndDashes = @"...-";
            newMorseCharacter.morseCharacter = morseV;
            break;
        case 'w': case 'W':
            newMorseCharacter.dotsAndDashes = @".--";
            newMorseCharacter.morseCharacter = morseW;
            break;
        case 'x': case 'X':
            newMorseCharacter.dotsAndDashes = @"-..-";
            newMorseCharacter.morseCharacter = morseX;
            break;
        case 'y': case 'Y':
            newMorseCharacter.dotsAndDashes = @"-.--";
            newMorseCharacter.morseCharacter = morseY;
            break;
        case 'z': case 'Z':
            newMorseCharacter.dotsAndDashes = @"--..";
            newMorseCharacter.morseCharacter = morseZ;
            break;
            
        case '0':
            newMorseCharacter.dotsAndDashes = @"-----";
            newMorseCharacter.morseCharacter = morse0;
            break;
        case '1':
            newMorseCharacter.dotsAndDashes = @".----";
            newMorseCharacter.morseCharacter = morse1;
            break;
        case '2':
            newMorseCharacter.dotsAndDashes = @"..---";
            newMorseCharacter.morseCharacter = morse2;
            break;
        case '3':
            newMorseCharacter.dotsAndDashes = @"...--";
            newMorseCharacter.morseCharacter = morse3;
            break;
        case '4':
            newMorseCharacter.dotsAndDashes = @"....-";
            newMorseCharacter.morseCharacter = morse4;
            break;
        case '5':
            newMorseCharacter.dotsAndDashes = @".....";
            newMorseCharacter.morseCharacter = morse5;
            break;
        case '6':
            newMorseCharacter.dotsAndDashes = @"-....";
            newMorseCharacter.morseCharacter = morse6;
            break;
        case '7':
            newMorseCharacter.dotsAndDashes = @"--...";
            newMorseCharacter.morseCharacter = morse7;
            break;
        case '8':
            newMorseCharacter.dotsAndDashes = @"---..";
            newMorseCharacter.morseCharacter = morse8;
            break;
        case '9':
            newMorseCharacter.dotsAndDashes = @"----.";
            newMorseCharacter.morseCharacter = morse9;
            break;
            
        default:
            break;
    }
    
    return newMorseCharacter;
}



@end
