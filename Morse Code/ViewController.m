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

@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIView *interfacePanel;

@property (nonatomic, strong) MorseCodeMessage *message;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _message = [MorseCodeMessage new];
    _interfacePanel.layer.cornerRadius = _interfacePanel.frame.size.width * .1;
    _interfacePanel.backgroundColor = [UIColor colorWithRed:.4 green:8 blue:.9 alpha:.7];

	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)translateButton:(id)sender {
    
    _message.untranslatedString = _textField.text;
    _label.text = _message.translatedString;
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)flash:(CGFloat)interval {
    
    AVCaptureDevice *flasher = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flasher hasTorch] && [flasher hasFlash] ) {
        
        //turn torch on
        [flasher lockForConfiguration:nil];
        [flasher setTorchMode:AVCaptureTorchModeOn];
        [flasher unlockForConfiguration];
        
        usleep(interval);
        
        //turn torch off
        [flasher lockForConfiguration:nil];
        [flasher setTorchMode:AVCaptureTorchModeOff];
        [flasher unlockForConfiguration];

    }
}


- (IBAction)sendMessage:(id)sender {
    
    NSOperationQueue *morseQueue = [NSOperationQueue new];
    
    [morseQueue addOperationWithBlock:^{
        
        if (!_message.translatedString.length) return;
        
        for (NSInteger i = 1; i < (_message.translatedString.length); i++) {
            
            switch ([_message.translatedString characterAtIndex:i]) {
                    
                case '1': //flash 1 microsecond followed by 1 microsecond pause
                    [self flash:100000];
                    usleep(100000);
                    break;
                    
                case '3': //flash 3 microseconds followed by 1 microsecond pause
                    [self flash:300000];
                    usleep(100000);
                    break;
                    
                case '0': //pause flash sequence 7 microseconds
                    usleep(700000);
                    break;
            }
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"Done");
        }];
    }];
}

//dismiss keyboard when anything is touched
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIControl *control in self.view.subviews) {
        if ([control isKindOfClass:[UITextField class]] || [control isKindOfClass:[UITextView class]] ) {
            [control endEditing:YES];
        }
    }
}

@end
