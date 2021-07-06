//
//  ProductCell.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryImageCell : UICollectionViewCell

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) UIImageView *smallImageView;

@property (nonatomic, copy) void(^oneTapped)(CategoryImageCell *cell);
//@property (nonatomic, copy) void(^longPressed)(FoodCategoryCollectionCell *cell);

@end
