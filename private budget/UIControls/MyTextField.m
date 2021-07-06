//
//  MyTextField.m
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 4/11/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = BLACK_COLOR.CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 5.0f;
        
        self.borderStyle = UITextBorderStyleNone;
        self.font = FONT_NORMAL_SMALL;
        self.textColor = BLACK_COLOR;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.returnKeyType = UIReturnKeyDone;
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.keyboardType = UIKeyboardTypeDefault;
    }
    return self;
}

//placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 5);
}

//text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 5);
}

@end
