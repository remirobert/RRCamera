RRCamera
==================

[![CI Status](http://img.shields.io/travis/remirobert/RRCustomPageController.svg?style=flat)](https://travis-ci.org/remirobert/RRCamera)
[![Version](https://img.shields.io/cocoapods/v/RRCustomPageController.svg?style=flat)](http://cocoadocs.org/docsets/RRCamera)
[![License](https://img.shields.io/cocoapods/l/RRCustomPageController.svg?style=flat)](http://cocoadocs.org/docsets/RRColorAverageBanner)
[![Platform](https://img.shields.io/cocoapods/p/RRCustomPageController.svg?style=flat)](http://cocoadocs.org/docsets/RRCamera)

RRCamera Controler is to manage the camera device. you can crop the picture. it uses AVFoundation framework.

Overview Delegates
==================

RRCamera provides you powerfull delegates to manage functionnality from the main Controller.

``` Objective-C

@protocol RRCameraDelegate

@optional
- (void) cameraCanceled;
- (void) switchCamera:(AVCaptureDevicePosition)cameraPosition;

@required
- (void) takePictureDone:(UIImage *)image;

@end

```

Overview configuration
======================

**You are free to change some parameters:**

``` Objective-C
@property (nonatomic, assign) BOOL allowSwitchDevice;
```
Enables or desables change between front and back camera.

``` Objective-C
@property (nonatomic, assign) AVCaptureDevicePosition defaultDevice;
```
set the camera position by default (by **AVCaptureDevicePositionBack** or **AVCaptureDevicePositionFront**), it will display when launching the controller.

``` Objective-C
@property (nonatomic, strong) UIView *customView;
```
You can put your own interfarce, depending on your design. You must set the customView for displaying you custom interface. For controls Bouttons (take picture, cancel controller, or switch camera), you must specify a **tag** for each button:
 - 1: **Take picture**
 - 2: **Cancel controller**
 - 3: **Switch Camera**

If you don't specify the tag, the functionnality will not be implemented.
If you don't provide custom interface, a default interface will be displayed.

``` Objective-C
@property (nonatomic, assign) CGSize sizeCropPicture;
```
Allows you to specify the size of your output picture. The display preview will be of this size and the UIImage on the delegate takePictureDone as well.

Usage
=====

``` Objective-c
- (void) takePictureDone:(UIImage *)image {
    [viewImage setImage:image];
    [camera dismissViewControllerAnimated:YES completion:nil];
}

- (void) takePicture {
    camera = [[RRCamera alloc] init];
    
    UIView *customUI = [[RRCustomView alloc] initWithFrame:self.view.frame];
    camera.customView = customUI;
    camera.delegate = self;
    camera.sizeCropPicture = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height);
    [self presentViewController:camera animated:YES completion:nil];
}
    
```
**For more details and examples, refer to the example project.**

## Installation

RRCamera is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "RRCamera"

## Author

remirobert, remi.robert@epitech.eu

## License

RRCamera is available under the MIT license. See the LICENSE file for more info.
