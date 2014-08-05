//
//  RRCamera.m
//  Wow
//
//  Created by Remi Robert on 02/08/14.
//  Copyright (c) 2014 remirobert. All rights reserved.
//

#import "RRCamera.h"

@interface RRCamera ()
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) AVCaptureDevicePosition currentDevicePosition;
@property (nonatomic, strong) UIView *mask1;
@property (nonatomic, strong) UIView *mask2;
@property (nonatomic, strong) UIView *maskSide1;
@property (nonatomic, strong) UIView *maskSide2;
@end

@implementation RRCamera

#pragma mark - camera function

- (void) takePicture {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             UIImage *image = [[UIImage alloc] initWithData:imageData];
             
             CGAffineTransform rotateTransform = CGAffineTransformIdentity;
             
             switch (image.imageOrientation) {
                 case UIImageOrientationDown:
                     rotateTransform = CGAffineTransformRotate(rotateTransform, M_PI);
                     rotateTransform = CGAffineTransformTranslate(rotateTransform, -image.size.width, -image.size.height);
                     break;
                     
                 case UIImageOrientationLeft:
                     rotateTransform = CGAffineTransformRotate(rotateTransform, M_PI_2);
                     rotateTransform = CGAffineTransformTranslate(rotateTransform, 0.0, -image.size.height);
                     break;
                     
                 case UIImageOrientationRight:
                     rotateTransform = CGAffineTransformRotate(rotateTransform, -M_PI_2);
                     rotateTransform = CGAffineTransformTranslate(rotateTransform, -image.size.width, 0.0);
                     break;
                     
                 default:
                     break;
             }
             
             CGFloat pourcentHeight = ([UIScreen mainScreen].bounds.size.height - _sizeCropPicture.height) / 2 *
             100 / [UIScreen mainScreen].bounds.size.height;
             CGFloat heightImage = image.size.height * pourcentHeight / 100;
             
             CGFloat pourcentWidth = ([UIScreen mainScreen].bounds.size.width - _sizeCropPicture.width) / 2 *
             100 / [UIScreen mainScreen].bounds.size.width;
             CGFloat widthImage = image.size.width * pourcentWidth / 100;
             
             CGRect rotatedCropRect = CGRectApplyAffineTransform(CGRectMake(widthImage, heightImage,
                                                                            image.size.width - widthImage * 2,
                                                                            image.size.height - heightImage * 2),
                                                                 rotateTransform);
             
             CGImageRef croppedImage = CGImageCreateWithImageInRect([image CGImage], rotatedCropRect);
             UIImage *result = [UIImage imageWithCGImage:croppedImage scale:[UIScreen mainScreen].scale
                                             orientation:image.imageOrientation];
             CGImageRelease(croppedImage);
             
             if (_currentDevicePosition == AVCaptureDevicePositionFront) {
                 result = [UIImage imageWithCGImage:result.CGImage scale:1.0 orientation:UIImageOrientationLeft + 4];
             }
             
             if ([self.delegate respondsToSelector:@selector(takePictureDone:)]) {
                 [self.delegate takePictureDone:result];
             }
         }
     }];
}

- (void) cancelCamera {
    if ([self.delegate respondsToSelector:@selector(cancelCamera)]) {
        [self.delegate cameraCanceled];
    }
}

- (void) changeDevice {
    if (_allowSwitchDevice == NO)
        return ;
    NSArray *inputs = self.session.inputs;
    for (AVCaptureDeviceInput *currentInput in inputs ) {
        AVCaptureDevice *device = (_currentDevicePosition == AVCaptureDevicePositionBack) ?
        [self frontCamera] : [self backCamera];
        if ([device hasMediaType:AVMediaTypeVideo]) {
            AVCaptureDeviceInput *newInput = nil;
            
            newInput =  [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            [self.session beginConfiguration];
            [self.session removeInput:currentInput];
            [self.session addInput:newInput];
            [self.session commitConfiguration];
            
            if ([self.delegate respondsToSelector:@selector(switchCamera:)]) {
                [self.delegate switchCamera:_currentDevicePosition];
            }
            break ;
        }
    }
}

#pragma mark - interface management

- (void) initMask {
    CGFloat sizeHeight = ([UIScreen mainScreen].bounds.size.height - _sizeCropPicture.height) / 2;
    
    _mask1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, sizeHeight)];
    _mask2 = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - sizeHeight,
                                                             [UIScreen mainScreen].bounds.size.width, sizeHeight)];
    
    _mask1.backgroundColor = MASK_COLOR;
    _mask2.backgroundColor = MASK_COLOR;
    
    CGFloat sizeWidth = ([UIScreen mainScreen].bounds.size.width - _sizeCropPicture.width) / 2;

    _maskSide1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeWidth, [UIScreen mainScreen].bounds.size.height)];
    _maskSide2 = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - sizeWidth, 0,
                                                      sizeWidth, [UIScreen mainScreen].bounds.size.height)];

    _maskSide1.backgroundColor = MASK_COLOR;
    _maskSide2.backgroundColor = MASK_COLOR;
    
    [self.view addSubview:_mask1];
    [self.view addSubview:_mask2];
    [self.view addSubview:_maskSide1];
    [self.view addSubview:_maskSide2];
}

- (void) initDefaultUi {
    UIButton *takePicture = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    [takePicture setTitle:@"take Picture" forState:UIControlStateNormal];
    
    [takePicture addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [takePicture setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_mask2 addSubview:takePicture];
    
    if (_allowSwitchDevice == YES) {
        UIButton *device = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
        [device setTitle:@"device" forState:UIControlStateNormal];
        [device setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [device addTarget:self action:@selector(changeDevice) forControlEvents:UIControlEventTouchUpInside];
        [_mask1 addSubview:device];
    }
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 50)];
    [cancel setTitle:@"cancel" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
    [_mask2 addSubview:cancel];
}

- (void) configureCustomUi:(UIView *)customView {
    if (customView == nil)
        return ;
    for (UIView *currentObject in customView.subviews) {
        if ([currentObject isMemberOfClass:[UIButton class]]) {
            if (((UIButton *)currentObject).tag == 1) {
                [((UIButton *)currentObject) addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (((UIButton *)currentObject).tag == 2) {
                [((UIButton *)currentObject) addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (((UIButton *)currentObject).tag == 3) {
                [((UIButton *)currentObject) addTarget:self action:@selector(changeDevice) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

#pragma mark - Camera device management

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            _currentDevicePosition = AVCaptureDevicePositionFront;
            return (device);
        }
    }
    return (nil);
}

- (AVCaptureDevice *)backCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            _currentDevicePosition = AVCaptureDevicePositionBack;
            return (device);
        }
    }
    return (nil);
}

#pragma mark - Avfoundation init

- (void) initAvFoundation {
    _session = [[AVCaptureSession alloc] init];
	_session.sessionPreset = AVCaptureSessionPresetHigh;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];

    captureVideoPreviewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                [UIScreen mainScreen].bounds.size.height);
	[self.view.layer addSublayer:captureVideoPreviewLayer];
	
    AVCaptureDevice *device = (_currentDevicePosition == AVCaptureDevicePositionBack) ?
    [self backCamera] : [self frontCamera];

	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
	if (!input) {
        NSLog(@"Error open input device");
        return ;
	}
	[_session addInput:input];
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    [_session addOutput:_stillImageOutput];
    
	[_session startRunning];
}

- (void) viewDidAppear:(BOOL)animated {
    _currentDevicePosition = _defaultDevice;
    [self initAvFoundation];
    [self initMask];
    if (_customView == nil) {
        [self initDefaultUi];
    }
    else {
        [self configureCustomUi:_customView];
        [self.view addSubview:_customView];
    }
}

- (instancetype) init {
    self = [super init];
    
    if (self != nil) {
        self.view.backgroundColor = [UIColor redColor];
        _currentDevicePosition = AVCaptureDevicePositionFront;
        _defaultDevice = AVCaptureDevicePositionBack;
        _allowSwitchDevice = YES;
        _sizeCropPicture = CGSizeMake([UIScreen mainScreen].bounds.size.width, 480);
    }
    return (self);
}

@end
