//
//  HomeViewController.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainAbstractViewController.h"

#import <CoreData/CoreData.h>

@interface HomeViewController : MainAbstractViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
