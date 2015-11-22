//
//  CategoryObject.h
//  private budget
//
//  Created by Enkhdulguun on 11/22/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryObject : NSObject

@property (nonatomic, strong) NSString *category_image;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSNumber *category_type;
@property (nonatomic, strong) NSNumber *itemid;

@end
