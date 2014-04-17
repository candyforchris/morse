//
//  TorchControllerDelegate.h
//  Morse Code
//
//  Created by Christopher Cohen on 4/16/14.
//  Copyright (c) 2014 Christopher Cohen. All rights reserved.
//


 // YourViewController.h:
 
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MorseCodeMessage.h"

@protocol TorchControlleDelegate <NSObject>


@required
-(void)updateHud:(NSString *)untranslatedCharacter;
-(void)terminateHud;

@optional
//-(void)optionalDelegateMethodOne;
//-(void)optionalDelegateMethodTwo:(NSString *)withArgument;

 @end

 @interface TorchController: NSObject
 
 @property (nonatomic, weak) id<TorchControlleDelegate> delegate;

-(void)transmitMessage: (MorseCodeMessage *)message;

 @end
 
