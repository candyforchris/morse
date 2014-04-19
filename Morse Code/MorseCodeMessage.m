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
    
    _romanCharacterString = @"";
    NSString *morseCharacter = @"";
    
    for (NSInteger i = 0; i < (romanCharacterString.length); i++) {
        
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
            default: morseCharacter  = NULL;    break;
                
        } //end switch
        
        if (morseCharacter) {
            
            //compose morse character script
            _morseCharacterString = [NSString stringWithFormat:@"%@|%@", _morseCharacterString, morseCharacter];
            
            //recompose roman character string
            _romanCharacterString = [NSString stringWithFormat:@"%@%c", _romanCharacterString, [romanCharacterString characterAtIndex:i]];
        }
    }
}

+(char)translateMorseToChar:(NSString *)string
{
    char pants;
    
    string = [string stringByReplacingOccurrencesOfString:@"2" withString:@"3"];
    
    int chraint = [string intValue];
    
    
    
//    NSLog(@"%d", chraint);
    
    
    switch (chraint) {
        case 13:    pants = 'A'; break;
        case 3111:  pants = 'B'; break;
        case 3131:  pants = 'C'; break;
        case 311:   pants = 'D'; break;
        case 1:     pants = 'E'; break;
        case 1131:  pants = 'F'; break;
        case 331:   pants = 'G'; break;
        case 1111:  pants = 'H'; break;
        case 11:    pants = 'I'; break;
        case 1333:  pants = 'J'; break;
        case 313:   pants = 'K'; break;
        case 1311:  pants = 'L'; break;
        case 33:    pants = 'M'; break;
        case 31:    pants = 'N'; break;
        case 333:   pants = 'O'; break;
        case 1331:  pants = 'P'; break;
        case 3313:  pants = 'Q'; break;
        case 131:   pants = 'R'; break;
        case 111:   pants = 'S'; break;
        case 3:     pants = 'T'; break;
        case 113:   pants = 'U'; break;
        case 1113:  pants = 'V'; break;
        case 133:   pants = 'W'; break;
        case 3113:  pants = 'X'; break;
        case 3133:  pants = 'Y'; break;
        case 3311:  pants = 'Z'; break;
                
                //numeric values
        case 33333: pants = '0'; break;
        case 13333: pants = '1'; break;
        case 11333: pants = '2'; break;
        case 11133: pants = '3'; break;
        case 11113: pants = '4'; break;
        case 11111: pants = '5'; break;
        case 31111: pants = '6'; break;
        case 33111: pants = '7'; break;
        case 33311: pants = '8'; break;
        case 33331: pants = '9'; break;
                
                //space
            
        default:    pants = ' '; break;
                
    } //end switch
    
    return pants;
}


@end
