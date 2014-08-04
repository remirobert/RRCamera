//
//  RRViewController.h
//  Wow
//
//  Created by Remi Robert on 02/08/14.
//  Copyright (c) 2014 remirobert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RRCamera.h"

@interface RRViewController : UIViewController <UIImagePickerControllerDelegate, RRCameraDelegate>

@property(nonatomic, retain) IBOutlet UIView *vImagePreview;

@end
