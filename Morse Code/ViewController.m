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
#import "math.h"

#define HIGH_BLUE_LEVEL (_averageAmbientBlueness * 1.2)
#define FRAME_RATE 10
#define MINIMUM_FRAMES_OF_LIGHT 3
#define COMPARISON_PIXEL_ARRAY_LENGTH 102000

enum CurrentState {
    light,
    dark,
} currentState;

@interface ViewController () <UITextFieldDelegate, TorchControlleDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIView *interfacePanel;
@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (nonatomic, strong) TorchController *torchController;

//video capture properties
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureVideoDataOutput *output;

//video capture input
@property (nonatomic, strong) NSString *characterElementString, *messageString;
@property (nonatomic) NSInteger frameCounter, flashFrameCounter, darkFrameCounter;

//text parsing and interpretation properties
@property (nonatomic, strong) NSDate *lastEvent, *currentEvent;

@property (nonatomic, strong) MorseCodeMessage *message;


@end

@implementation ViewController {
    //light metering
    int pixelInArray;
    int pixelLuminosity;
    int currentFrameLightPeakingLevel;
    int previousFrameLightPeakingLevel;
    int luminosityEquator;
    
    //light peak analysis
    BOOL lightMeterCalibrated;
    
    //frame buffer comparision
    int pixelsLighterThanPreviousFrame;
    size_t bufferWidth;
    size_t bufferHeight;
    size_t rowBytes;
    size_t pixelBytes;
    unsigned char *base;
    int previousFrame[COMPARISON_PIXEL_ARRAY_LENGTH];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //setup video capture properties
    _characterElementString = @" ";
    _messageString          = @" ";
    _frameCounter           = _flashFrameCounter     = _darkFrameCounter       = 0;
    lightMeterCalibrated    = NO;
    
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

- (IBAction)getMessage:(id)sender {

    [ProgressHUD show:@"Calibrating Lightmeter"];
    [_sendMessageButton setEnabled:NO];
    [_textField setEnabled:NO];
    _interfacePanel.alpha = .5;

    [self setupCaptureSession];
    
}

- (AVCaptureDevice *)searchForBackCameraIfAvailable
{
    //  look at all the video devices and get the first one that's on the front
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == AVCaptureDevicePositionBack)
        {
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if ( ! captureDevice)
    {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
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

#pragma mark - video input

// Create and configure a capture session and start it running
- (void)setupCaptureSession
{
    NSLog(@"setup capture session");
    
    // Create new session
    _session = [AVCaptureSession new];
    
    // Configure the session to produce low resolution video frames
    _session.sessionPreset = AVCaptureSessionPreset352x288;
    
    // Find a suitable AVCaptureDevice
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Create a device input with the device and add it to the session.
    NSError *error;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (error) {
        NSLog(@"error establishing device input");
        return;
    }

    //add input to session
    [_session addInput:_input];
    
    //configure device
    [_device lockForConfiguration:nil];
    [_device setExposureMode:AVCaptureExposureModeLocked];
    
    [_device setActiveVideoMinFrameDuration:CMTimeMake(1, FRAME_RATE)];
    [_device unlockForConfiguration];
    
    // Create a VideoDataOutput and add it to the session
    _output = [AVCaptureVideoDataOutput new];
    [_session addOutput:_output];
    
    // Configure your output
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [_output setSampleBufferDelegate:self queue:queue];
    
    // Specify the pixel format
    _output.videoSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    // Start the session running to start the flow of data
    [_session startRunning];

}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{

    //establish baseline

    
    [self analyzeCameraFrameForLuminocity:sampleBuffer];
    
}


- (void)analyzeCameraFrameForLuminocity:(CMSampleBufferRef)sampleBuffer
{
    
    CVPixelBufferRef pixelBuffer =
    CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
    
    bufferWidth     = CVPixelBufferGetWidth(pixelBuffer);
    bufferHeight    = CVPixelBufferGetHeight(pixelBuffer);
    rowBytes        = CVPixelBufferGetBytesPerRow(pixelBuffer);
    pixelBytes      = rowBytes/bufferWidth;
    
    base            = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    pixelLuminosity = pixelInArray = currentFrameLightPeakingLevel = 0;
    
    //analyze bitmap for luminosity information
    //programmed by CHRIS COHEN
    for( int row = 0; row < bufferHeight; row++ ) {
        for( int column = 0; column < bufferWidth; column++ ) {

            unsigned char *pixel = base + (row * rowBytes) + (column * pixelBytes);
           
            //pixel luminosity is the sum of red, green, and blue color components
            pixelLuminosity = (pixel[0] + pixel[1] + pixel[2]);
            
            //if pixel is brighter than coresponding pixel in previous frame
            if (pixelLuminosity > previousFrame[pixelInArray]) {
                currentFrameLightPeakingLevel += (pixelLuminosity - previousFrame[pixelInArray]);
            } else currentFrameLightPeakingLevel -= (previousFrame[pixelInArray] - pixelLuminosity);

            //add pixel luminosity value to static array for comparison with next frame in buffer
            previousFrame[pixelInArray++] = pixelLuminosity;
            }
    }
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0 );
    
    
    if (lightMeterCalibrated) {
        
        //Act on light meter levels outside the luminosity equator
        if (abs(currentFrameLightPeakingLevel) > luminosityEquator * 1) {
            
            //handle new flash state
            if (currentFrameLightPeakingLevel > 0) {
                currentState = light;
                _flashFrameCounter++;
                _darkFrameCounter = 0;
                
            //handle new dark state
            } else {
                currentState = dark;
                _darkFrameCounter++;
                [self interpretFlashIntervals];
            }
            
        //Act on sustain state
        } else {
            if (currentState == light) {
                _flashFrameCounter++;
            } else {
                _darkFrameCounter++;
                [self interpretFlashIntervals];
            }
            
        }
        
        
    } else {
        //Calibrate Light Meter
        //programmed by MATT VOSS
        if (_frameCounter > (FRAME_RATE * 2)) {
            
            lightMeterCalibrated = YES;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [ProgressHUD dismiss];
                [_sendMessageButton setEnabled:YES];
                [_textField setEnabled:YES];
                _interfacePanel.alpha = 1;
            } ];
            
        } else {
            
            //calibrate meter
            if (_frameCounter > 3) {
                if (abs(currentFrameLightPeakingLevel) > luminosityEquator) {
                    luminosityEquator = abs(currentFrameLightPeakingLevel);
                }
            } else {
                luminosityEquator = abs(currentFrameLightPeakingLevel);
            }
        }
    }

    _frameCounter++;
    
    previousFrameLightPeakingLevel = currentFrameLightPeakingLevel;
    
}



//Programmed by MATT VOSS
-(void)interpretFlashIntervals
{
        switch (_darkFrameCounter) {
            case 1: _characterElementString = [NSString stringWithFormat:@"%@%d", _characterElementString, _flashFrameCounter];
                _flashFrameCounter = 0;
                break;
            case 3:
                _messageString = [NSString stringWithFormat:@"%@%c", _messageString, [MorseCodeMessage translateMorseToChar:_characterElementString]];
                _characterElementString = @" ";
                NSLog(@"%@", _messageString);
                break;
            case 7:
                _messageString = [NSString stringWithFormat:@"%@ ", _messageString];
                break;
            case 37: //end of data
                break;
            default: //do nothing..
                break;
        }
}

@end
