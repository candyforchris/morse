//
//  TorchControllerDelegate.m
//  Morse Code
//
//  Created by Christopher Cohen on 4/16/14.
//  Copyright (c) 2014 Christopher Cohen. All rights reserved.
//

#import "TorchController.h"
#import <AVFoundation/AVFoundation.h>
#import "MorseCodeMessage.h"
#import "ProgressHUD.h"
#import <CoreMotion/CoreMotion.h>

@interface TorchController () <UIApplicationDelegate>

@property (nonatomic) bool earlyTermination;
@property (strong, nonatomic) NSOperationQueue *motionRecognizerQueue, *morseQueue;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation TorchController

-(void)transmitMessage: (MorseCodeMessage *)message {
    
    //initialize thread queues
    _morseQueue             = [NSOperationQueue new];
    _motionRecognizerQueue  = [NSOperationQueue new];

    //motion manager
    _motionManager          = [CMMotionManager new];
    [self setupShakeToCancelMotionManager];
    
    //set early termination flag to 'NO'
    _earlyTermination = NO;
    
    [_morseQueue addOperationWithBlock:^{
    
        //translated & untranslated charcter incrementors
        NSInteger i, j = 0;
    
        //iterate through each character in the translated string and display them via flash
        for (i = 1; i < (message.morseCharacterString.length); i++) {
        
            if (_earlyTermination) goto TERMINATION_POINT;
        
            //display coresponding roman characer in hud
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.delegate updateHud:[NSString stringWithFormat:@"%c", [message.romanCharacterString characterAtIndex:j]]];
            }];
    
            //translate morse script into flashes of light
            switch ([message.morseCharacterString characterAtIndex:i]) {
                    
                case '1': //flash 1 unit followed by 1 unit pause
                    [TorchController toggleFlash:100000]; usleep(100000);
                    break;
                    
                case '3': //flash 3 units followed by 1 unit pause
                    [TorchController toggleFlash:300000]; usleep(100000);
                    break;
                    
                case '|': //pause flash sequence 3 units between words
                    usleep(200000); //this + the preceeding thread pause is 3 units
                    j++;            //increment the untranslated char counter
                    break;
                    
                case 'X': //pause flash sequence 7 units total
                    usleep(200000); //this + the preceeding, current, & forthcoming threadpause is 7 units
                    break;
                }
            }
    
        TERMINATION_POINT: //'goto' label
    
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_motionRecognizerQueue cancelAllOperations];
            [_morseQueue cancelAllOperations];
            [self.delegate terminateHud];
        }];
    }];
}

+(void)toggleFlash:(CGFloat)flashDuration {
    
    AVCaptureDevice *flasher = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flasher hasTorch] && [flasher hasFlash] ) {
        
        //turn torch on
        [flasher lockForConfiguration:nil];
        [flasher setTorchMode:AVCaptureTorchModeOn];
        [flasher unlockForConfiguration];
        
        usleep(flashDuration);
        
        //turn torch off
        [flasher lockForConfiguration:nil];
        [flasher setTorchMode:AVCaptureTorchModeOff];
        [flasher unlockForConfiguration];
        
    }
}

#pragma mark - Motion Manager
- (void)setupShakeToCancelMotionManager
{
    [_motionManager startAccelerometerUpdatesToQueue:_motionRecognizerQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        if (error) return;
        if ([accelerometerData acceleration].x > 1.5) _earlyTermination = YES;
    }];
}

@end
