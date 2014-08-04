//
//  RRViewController.m
//  Wow
//
//  Created by Remi Robert on 02/08/14.
//  Copyright (c) 2014 remirobert. All rights reserved.
//

#import "RRViewController.h"
#import "RRCustomView.h"

@interface RRViewController ()
{
    UIImagePickerController *controller;
    UIImageView *viewImage;
    RRCamera *camera;
}
@end

@implementation RRViewController

- (void) takePictureDone:(UIImage *)image {
    NSLog(@"receive picture %f %f", image.size.width, image.size.height);
    [viewImage setImage:image];
    [camera dismissViewControllerAnimated:YES completion:nil];
}

- (void) cameraCanceled {
    [camera dismissViewControllerAnimated:YES completion:nil];
}

- (void) switchCamera:(AVCaptureDevicePosition)cameraPosition {
    NSLog(@"switch position : %ld", cameraPosition);
}

- (void) take {
    camera = [[RRCamera alloc] init];
    
    UIView *customUI = [[RRCustomView alloc] initWithFrame:self.view.frame];
    camera.customView = customUI;
    camera.delegate = self;
    camera.sizeCropPicture = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height);
    [self presentViewController:camera animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *take = [[UIButton alloc] initWithFrame:CGRectMake(0, 500, [UIScreen mainScreen].bounds.size.width, 50)];
    [take setTitle:@"take picture" forState:UIControlStateNormal];
    [take setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:take];
    [take addTarget:self action:@selector(take) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    viewImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    viewImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:viewImage];
}

@end
