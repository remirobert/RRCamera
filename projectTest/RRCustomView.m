//
//  RRCustomView.m
//  Wow
//
//  Created by Remi Robert on 04/08/14.
//  Copyright (c) 2014 remirobert. All rights reserved.
//

#import "RRCustomView.h"

@implementation RRCustomView

- (void) initUI {
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
    [button1 setTitle:@"switch" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    button1.tag = 3;

    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100, 320, 50)];
    [button2 setTitle:@"clic !" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button2.tag = 1;

    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, 320, 50)];
    [button3 setTitle:@"quit" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button3.tag = 2;

    [self addSubview:button1];
    [self addSubview:button2];
    [self addSubview:button3];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

@end
