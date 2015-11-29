//
//  ProductCell.h
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 2/13/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryObject.h"

@interface CategoryCell : UICollectionViewCell

@property (nonatomic, strong) CategoryObject *category;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *smallImageView;

@property (nonatomic, copy) void(^oneTapped)(CategoryCell *cell);
//@property (nonatomic, copy) void(^longPressed)(FoodCategoryCollectionCell *cell);

@end
