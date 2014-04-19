//
//  MorseCodeMessage.h
//  Morse Code
//
//  Created by Christopher Cohen on 4/15/14.
//  Copyright (c) 2014 Christopher Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MorseCodeMessage : NSObject

@property (nonatomic, strong) NSString *romanCharacterString, *morseCharacterString;

-(void)setRomanCharacterString:(NSString *)romanCharacterString;
+(char)translateMorseToChar:(NSString *)string;

@end
