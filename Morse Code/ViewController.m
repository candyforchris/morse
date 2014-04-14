//
//  ViewController.m
//  Morse Code
//
//  Created by Christopher Cohen on 4/14/14.
//  Copyright (c) 2014 Christopher Cohen. All rights reserved.
//

#import "ViewController.h"
#import "MorseCodeCharacter.h"

@interface ViewController ()
@property (nonatomic, strong) NSString *inputString;
@property (nonatomic,strong) NSString *outputString;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _inputString = @"Hello World";
    _outputString = [NSString new];
    
    [self decomposeString:_inputString];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

}

-(void)decomposeString: (NSString *)string {
    NSLog(@"hi");
 for (int i = 0; i < string.length; i++) {
            _outputString = [NSString stringWithFormat:@"%@ %@", _outputString, [MorseCodeCharacter newWithChar:[_inputString characterAtIndex:i]].dotsAndDashes];
    }
   
    NSLog(@"%@", _outputString);
    
    return;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
