//
//  RRCamera.h
//  Wow
//
//  Created by Remi Robert on 02/08/14.
//  Copyright (c) 2014 remirobert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>

#define MASK_COLOR  [UIColor blackColor]

@protocol RRCameraDelegate;

@interface RRCamera : UIViewController

@property (nonatomic, assign) id<RRCameraDelegate> delegate;

- (instancetype) init;

@property (nonatomic, assign) BOOL allowSwitchDevice;
@property (nonatomic, assign) AVCaptureDevicePosition defaultDevice;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) CGSize sizeCropPicture;

@end

#pragma mark - Camera Delegate

@protocol RRCameraDelegate

@optional
- (void) cameraCanceled;
- (void) switchCamera:(AVCaptureDevicePosition)cameraPosition;

@required
- (void) takePictureDone:(UIImage *)image;

@end
