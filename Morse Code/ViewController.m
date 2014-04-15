//
//  ViewController.m
//  Morse Code
//
//  Created by Christopher Cohen on 4/14/14.
//  Copyright (c) 2014 Christopher Cohen. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MorseCodeMessage.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *morseTextField;
@property (strong, nonatomic) IBOutlet UILabel *morseLabel;
@property (strong, nonatomic) IBOutlet UIView *interfacePanel;

@property (nonatomic, strong) MorseCodeMessage *message;

@end

@implementation ViewController

- (IBAction)makeFlash:(id)sender {
    
    if (!_message.morseIntervalString.length) return;
    
    for (NSInteger i = 1; i < (_message.morseIntervalString.length); i++) {
            
        switch ([_message.morseIntervalString characterAtIndex:i]) {
                
            case '1': //flash 1 microsecond followed by 1 microsecond pause
                [self flashOn:100000];
                [self flashOff:100000];
                break;
                    
            case '3': //flash 3 microseconds followed by 1 microsecond pause
                [self flashOn:300000];
                [self flashOff:100000];
                break;
                    
            case '0': //pause flash sequence 7 microseconds
                usleep(600000);
                break;

        }
    }
}

-(void)flashOn:(CGFloat)interval {
    
    AVCaptureDevice *flasher = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flasher hasTorch] && [flasher hasFlash] ) {
        
        //turn torch on
        [flasher lockForConfiguration:nil];
        [flasher setTorchMode:AVCaptureTorchModeOn];
        [flasher unlockForConfiguration];
        
        //freeze thread
        usleep(interval);
    
    }
}

-(void)flashOff:(CGFloat)interval {
    
    AVCaptureDevice *flasher = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flasher hasTorch] && [flasher hasFlash] ) {
        
        //turn torch off
        [flasher lockForConfiguration:nil];
        [flasher setTorchMode:AVCaptureTorchModeOff];
        [flasher unlockForConfiguration];
        
        //freeze thread
        usleep(interval);

        
    }
}


- (void)viewDidLoad
{
    _message = [MorseCodeMessage new];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)translateButton:(id)sender {
    
    _message = [MorseCodeMessage newMessageFrom:_morseTextField.text];
    _morseLabel.text = _message.morseIntervalString;
    
    //NSOperationQueue *morseQueue = [NSOperationQueue new];
    
//    [morseQueue addOperationWithBlock:^{
//        NSString *translatedString = [NSString translateIntoMorseCode:_morseTextField.text];
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            _morseLabel.text = translatedString;
//        }];
//    }];
    
    //[self performSelectorInBackground:@selector(translate) withObject:_morseTextField];
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
