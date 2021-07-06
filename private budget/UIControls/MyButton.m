//
//  MyButton.m
//  iSalonRepo
//
//  Created by Sodtseren Enkhee on 4/24/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:FONT_NORMAL_SMALL];
        [self.titleLabel setNumberOfLines:2];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
//        self.layer.borderColor = BLACK_COLOR.CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
        [self setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
    }
    return self;
}

@end
