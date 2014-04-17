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
#import "ProgressHUD.h"
#import "TorchController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController () <UITextFieldDelegate, TorchControlleDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIView *interfacePanel;
@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (nonatomic, strong) TorchController *torchController;


@property (nonatomic, strong) MorseCodeMessage *message;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //allocate and initialize objects
    _torchController    = [TorchController new];
    _message            = [MorseCodeMessage new];

    //assign delegate methods to self
    _torchController.delegate   = self;
    _textField.delegate         = self;
    
    //setup visual atributes of interface panel
    _interfacePanel.layer.cornerRadius  = _interfacePanel.frame.size.width * .1;
    _interfacePanel.backgroundColor     = [UIColor clearColor];
    _interfacePanel.layer.borderWidth   = 3;
    _interfacePanel.layer.borderColor   = [UIColor orangeColor].CGColor;
    _textField.layer.borderColor        = [UIColor clearColor].CGColor;
    _textField.backgroundColor          = [UIColor orangeColor];
    _textField.textColor                = [UIColor blackColor];
    _label.textColor                    = [UIColor orangeColor];
    self.view.backgroundColor           = [UIColor blackColor];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateHud:(NSString *)untranslatedCharacter {
    [ProgressHUD show:untranslatedCharacter];
}

-(void)terminateHud {
    [ProgressHUD dismiss];
    [_sendMessageButton setEnabled:YES];
    [_textField setEnabled:YES];
    _interfacePanel.alpha = 1;
}


- (IBAction)sendMessage:(id)sender {
    
    if (!_textField.text.length) return;
    
    [_sendMessageButton setEnabled:NO];
    [_textField setEnabled:NO];
    _interfacePanel.alpha = .5;

   [_torchController transmitMessage:_message];
}

//dismiss keyboard when anything is touched
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIControl *control in self.view.subviews) {
        [control endEditing:YES];
    }
}

#pragma mark - UITextField delegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _label.text = _message.morseCharacterString = @"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _message.romanCharacterString = _textField.text;
    _label.text = _message.morseCharacterString;
}


@end
