//
//  DashboardLegendScrollView.m
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 6/13/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "DashboardLegendView.h"
#import "LegendObject.h"

@interface DashboardLegendView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *myScrollView;

@end

@implementation DashboardLegendView
@synthesize legendArray;
@synthesize legendHeight;
@synthesize nameFont;
@synthesize valueFont;
@synthesize nameOffset;
@synthesize myScrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.myScrollView];
    }
    return self;
}

- (void)reloadData {
    [self.myScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int boundY = 0;
    int height = legendHeight;
    
    for (LegendObject *legend in self.legendArray) {
        {
            UIView *legendView = [[UIView alloc] initWithFrame:CGRectMake(0, boundY, self.myScrollView.bounds.size.width, height)];
            boundY += legendView.bounds.size.height;
            legendView.backgroundColor = CLEAR_COLOR;
            [self.myScrollView addSubview:legendView];
            
            int x = 0;
            {
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, (self.myScrollView.bounds.size.width-height)/2+self.nameOffset, height)];
                x += nameLabel.bounds.size.width;
                nameLabel.backgroundColor = CLEAR_COLOR;
                nameLabel.textColor = BLACK_COLOR;
                nameLabel.font = self.nameFont;
                nameLabel.textAlignment = NSTextAlignmentRight;
                [legendView addSubview:nameLabel];
                
                nameLabel.text = legend.name;
            }
            {
                UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(x+5, 5, height-10, height-10)];
                x += height;
                colorView.backgroundColor = legend.color;
                colorView.layer.cornerRadius = (height-10)/2;
                [legendView addSubview:colorView];
            }
            {
                UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, (self.myScrollView.bounds.size.width-height)/2-self.nameOffset, height)];
                valueLabel.backgroundColor = CLEAR_COLOR;
                valueLabel.textColor = BLACK_COLOR;
                valueLabel.font = self.valueFont;
                [legendView addSubview:valueLabel];
                
                valueLabel.text = legend.myvalue;
            }
        }
    }
    
    self.myScrollView.contentSize = CGSizeMake(self.myScrollView.bounds.size.width, boundY);
}

#pragma mark -
#pragma mark Getters
- (UIScrollView *)myScrollView {
    if (myScrollView == nil) {
        myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        myScrollView.backgroundColor = CLEAR_COLOR;
        myScrollView.delegate = self;
        myScrollView.decelerationRate = 0.1f;
        myScrollView.pagingEnabled = NO;
        myScrollView.alwaysBounceVertical = YES;
    }
    return myScrollView;
}

@end
