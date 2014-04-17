//
//  MorseCodeMessage.m
//  Morse Code
//
//  Created by Christopher Cohen on 4/15/14.
//  Copyright (c) 2014 Christopher Cohen. All rights reserved.
//

#import "MorseCodeMessage.h"

@implementation MorseCodeMessage

-(void)setRomanCharacterString:(NSString *)romanCharacterString {

    //set standard string
    _romanCharacterString = romanCharacterString;
    
    NSString *morseCharacter = @"";
    
    for (NSInteger i = 0; i < (_romanCharacterString.length); i++) {
        
        switch ([romanCharacterString characterAtIndex:i]) {
                
            //roman characters
            case 'a': case 'A': morseCharacter = @"13";     break;
            case 'b': case 'B': morseCharacter = @"3111";   break;
            case 'c': case 'C': morseCharacter = @"3131";   break;
            case 'd': case 'D': morseCharacter = @"311";    break;
            case 'e': case 'E': morseCharacter = @"1";      break;
            case 'f': case 'F': morseCharacter = @"1131";   break;
            case 'g': case 'G': morseCharacter = @"331";    break;
            case 'h': case 'H': morseCharacter = @"1111";   break;
            case 'i': case 'I': morseCharacter = @"11";     break;
            case 'j': case 'J': morseCharacter = @"1333";   break;
            case 'k': case 'K': morseCharacter = @"313";    break;
            case 'l': case 'L': morseCharacter = @"1311";   break;
            case 'm': case 'M': morseCharacter = @"33";     break;
            case 'n': case 'N': morseCharacter = @"31";     break;
            case 'o': case 'O': morseCharacter = @"333";    break;
            case 'p': case 'P': morseCharacter = @"1331";   break;
            case 'q': case 'Q': morseCharacter = @"3313";   break;
            case 'r': case 'R': morseCharacter = @"131";    break;
            case 's': case 'S': morseCharacter = @"111";    break;
            case 't': case 'T': morseCharacter = @"3";      break;
            case 'u': case 'U': morseCharacter = @"113";    break;
            case 'v': case 'V': morseCharacter = @"1113";   break;
            case 'w': case 'W': morseCharacter = @"133";    break;
            case 'x': case 'X': morseCharacter = @"3113";   break;
            case 'y': case 'Y': morseCharacter = @"3133";   break;
            case 'z': case 'Z': morseCharacter = @"3311";   break;
                
            //numeric values
            case '0': morseCharacter = @"33333"; break;
            case '1': morseCharacter = @"13333"; break;
            case '2': morseCharacter = @"11333"; break;
            case '3': morseCharacter = @"11133"; break;
            case '4': morseCharacter = @"11113"; break;
            case '5': morseCharacter = @"11111"; break;
            case '6': morseCharacter = @"31111"; break;
            case '7': morseCharacter = @"33111"; break;
            case '8': morseCharacter = @"33311"; break;
            case '9': morseCharacter = @"33331"; break;
                
            //space
            case ' ': morseCharacter = @"X"; break;
                
            default: break;
                
        } //end switch
        
        if (morseCharacter) {
            _morseCharacterString = [NSString stringWithFormat:@"%@|%@", _morseCharacterString, morseCharacter];
        }
    }
}


@end
