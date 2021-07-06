//
//  ProductCell.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBCategory.h"

@interface CategoryCell : UICollectionViewCell

@property (nonatomic, strong) DBCategory *category;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *smallImageView;

@property (nonatomic, copy) void(^oneTapped)(CategoryCell *cell);
//@property (nonatomic, copy) void(^longPressed)(FoodCategoryCollectionCell *cell);

@end
