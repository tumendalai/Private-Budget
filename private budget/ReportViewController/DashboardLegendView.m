//
//  DashboardLegendScrollView.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//
#import "DashboardLegendView.h"
#import "LegendObject.h"

@interface DashboardLegendView()<UIScrollViewDelegate>


@end

@implementation DashboardLegendView
@synthesize legendArray;
@synthesize legendHeight;
@synthesize nameFont;
@synthesize valueFont;
@synthesize nameOffset;
@synthesize myScrollView;
@synthesize is_pie_chart;
@synthesize nameTextAlignment;
@synthesize is_numbered;

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
    int number = 1;
    
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
                nameLabel.textAlignment = nameTextAlignment;
                [legendView addSubview:nameLabel];
                
                nameLabel.text = legend.name;
                if (is_numbered) {
                    nameLabel.text = [NSString stringWithFormat:@"%d. %@",number,nameLabel.text];
                    number++;
                }
            }
            {
                UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(x+5, 5, height-10, height-10)];
                x += height;
                colorView.backgroundColor = legend.color;
                if (is_pie_chart) {
                    colorView.layer.cornerRadius = (height-10)/2;
                }
                [legendView addSubview:colorView];
            }
            {
                UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, (self.myScrollView.bounds.size.width-height)/2-self.nameOffset, height)];
                valueLabel.backgroundColor = CLEAR_COLOR;
                valueLabel.textColor = BLACK_COLOR;
                valueLabel.font = self.valueFont;
                [legendView addSubview:valueLabel];
                
                valueLabel.text = [NSString stringWithFormat:@"%@%@",legend.myvalue,legend.symbol];
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
