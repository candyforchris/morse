//
//  MorseCodeMessage.m
//  Morse Code
//
//  Created by Christopher Cohen on 4/15/14.
//  Copyright (c) 2014 Christopher Cohen. All rights reserved.
//

#import "MorseCodeMessage.h"

@implementation MorseCodeMessage

-(void)setRomanCharacterString:(NSString *)oldRomanCharacterString {
    
    _morseCharacterString = @"X";
    _romanCharacterString = @"";
    NSString *morseCharacter = @"";
    
    SKIP_NON_ALPHANUMERIC:
    
    for (NSInteger i = 0; i < (oldRomanCharacterString.length); i++) {
        
        switch ([oldRomanCharacterString characterAtIndex:i]) {
                
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
                
                //non alphanumeric characters
            case '!': case '@': case '#': case '$': case '%': case '.': case ',': case ':': case ';':
                goto SKIP_NON_ALPHANUMERIC;
                break;
                
                //space
            default: morseCharacter  = @"X";break;
                
        } //end switch
        
        if (morseCharacter) {
            
            //compose morse character script
            _morseCharacterString = [NSString stringWithFormat:@"%@|%@", _morseCharacterString, morseCharacter];
            
            //recompose roman character string
            _romanCharacterString = [NSString stringWithFormat:@"%@%c", _romanCharacterString, [oldRomanCharacterString characterAtIndex:i]];
        }
    }
    
    _romanCharacterString = [NSString stringWithFormat:@"%@     ", _romanCharacterString];
    
}

+(char)translateMorseToChar:(NSString *)string
{
    char romanCharacter;
    
    //filter incoming data
    string = [string stringByReplacingOccurrencesOfString:@"0" withString:@"1"];
    string = [string stringByReplacingOccurrencesOfString:@"2" withString:@"3"];
    string = [string stringByReplacingOccurrencesOfString:@"4" withString:@"3"];
    string = [string stringByReplacingOccurrencesOfString:@"5" withString:@"3"];
    string = [string stringByReplacingOccurrencesOfString:@"6" withString:@"3"];
    string = [string stringByReplacingOccurrencesOfString:@"7" withString:@"3"];
    string = [string stringByReplacingOccurrencesOfString:@"8" withString:@"3"];
    string = [string stringByReplacingOccurrencesOfString:@"9" withString:@"3"];


    switch ([string intValue]) {
        case 13:    romanCharacter = 'A'; break;
        case 3111:  romanCharacter = 'B'; break;
        case 3131:  romanCharacter = 'C'; break;
        case 311:   romanCharacter = 'D'; break;
        case 1:     romanCharacter = 'E'; break;
        case 1131:  romanCharacter = 'F'; break;
        case 331:   romanCharacter = 'G'; break;
        case 1111:  romanCharacter = 'H'; break;
        case 11:    romanCharacter = 'I'; break;
        case 1333:  romanCharacter = 'J'; break;
        case 313:   romanCharacter = 'K'; break;
        case 1311:  romanCharacter = 'L'; break;
        case 33:    romanCharacter = 'M'; break;
        case 31:    romanCharacter = 'N'; break;
        case 333:   romanCharacter = 'O'; break;
        case 1331:  romanCharacter = 'P'; break;
        case 3313:  romanCharacter = 'Q'; break;
        case 131:   romanCharacter = 'R'; break;
        case 111:   romanCharacter = 'S'; break;
        case 3:     romanCharacter = 'T'; break;
        case 113:   romanCharacter = 'U'; break;
        case 1113:  romanCharacter = 'V'; break;
        case 133:   romanCharacter = 'W'; break;
        case 3113:  romanCharacter = 'X'; break;
        case 3133:  romanCharacter = 'Y'; break;
        case 3311:  romanCharacter = 'Z'; break;
            
            //numeric values
        case 33333: romanCharacter = '0'; break;
        case 13333: romanCharacter = '1'; break;
        case 11333: romanCharacter = '2'; break;
        case 11133: romanCharacter = '3'; break;
        case 11113: romanCharacter = '4'; break;
        case 11111: romanCharacter = '5'; break;
        case 31111: romanCharacter = '6'; break;
        case 33111: romanCharacter = '7'; break;
        case 33311: romanCharacter = '8'; break;
        case 33331: romanCharacter = '9'; break;
            
            //space
            
        default:    romanCharacter = ' '; break;
            
    } //end switch
    
    return romanCharacter;
}


@end
