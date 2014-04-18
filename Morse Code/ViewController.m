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

- (IBAction)getMessage:(id)sender {

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
    
    [_device setActiveVideoMinFrameDuration:CMTimeMake(1, 10)];
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

    [self analyzeCameraFrameForLuminocity:sampleBuffer];
    
}


- (void)analyzeCameraFrameForLuminocity:(CMSampleBufferRef)sampleBuffer
{
    
    CVPixelBufferRef pixelBuffer =
    CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
    
    int redSaturation     = 0;
    int blueSaturation    = 0;
    int greenSaturation   = 0;
    
    int bufferWidth     = CVPixelBufferGetWidth(pixelBuffer);
    int bufferHeight    = CVPixelBufferGetHeight(pixelBuffer);
    int rowBytes        = CVPixelBufferGetBytesPerRow(pixelBuffer);
    int pixelBytes      = rowBytes/bufferWidth;
    
    unsigned char *base = (unsigned char *)
    CVPixelBufferGetBaseAddress(pixelBuffer);
    
    for( int row = 0; row < bufferHeight; row+=4 ) {
        for( int column = 0; column < bufferWidth; column+=4 ) {
            
            unsigned char *pixel = base + (row * rowBytes) + (column * pixelBytes);
            
            // BGRA pixel format
            redSaturation     += pixel[2];
            blueSaturation    += pixel[0];
            greenSaturation   += pixel[1];
            
            }
    }
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0 );

    NSLog(@"redness: %0.5f %%",  (255.0*redSaturation) / ((255.0*bufferWidth*bufferHeight)/4));
    //NSLog(@"blueness: %.1f %%", (255.0*blueSaturation) / ((255.0*bufferWidth*bufferHeight)/4));
    NSLog(@"greeness: %0.5f %%", (255.0*greenSaturation) / ((255.0*bufferWidth*bufferHeight)/4));
    
}

@end
