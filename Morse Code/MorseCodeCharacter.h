//
//  MorseCodeCharacter.h
//  Morse Code
//
//  Created by Christopher Cohen on 4/14/14.
//  Copyright (c) 2014 Christopher Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MorseCodeCharacter : NSObject


typedef enum {
    //characters
    morseA,
    morseB,
    morseC,
    morseD,
    morseE,
    morseF,
    morseG,
    morseH,
    morseI,
    morseJ,
    morseK,
    morseL,
    morseM,
    morseN,
    morseO,
    morseP,
    morseQ,
    morseR,
    morseS,
    morseT,
    morseU,
    morseV,
    morseW,
    moresR,
    morseX,
    morseY,
    morseZ,
    //numbers
    morse0,
    morse1,
    morse2,
    morse3,
    morse4,
    morse5,
    morse6,
    morse7,
    morse8,
    morse9,
} MorseChar;


@property (nonatomic, strong) NSString *dotsAndDashes;
@property MorseChar morseCharacter;



+(instancetype)newWithChar: (unichar)character;



@end
