//
//  SettingsViewController.h
//  private budget
//
//  Created by tuguldur purevnyam on 08.11.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainAbstractViewController.h"
#import <CoreData/CoreData.h>

@interface SettingsViewController : MainAbstractViewController

@property (nonatomic, copy) void (^addButtonClicked)();
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
