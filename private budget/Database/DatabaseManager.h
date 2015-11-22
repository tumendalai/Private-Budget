//
//  DatabaseManager.h
//  XAAH
//
//  Created by Sodtseren on 9/24/12.
//  Copyright (c) 2012 Sodtseren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//
#import "DBCurrency.h"
#import "DBTransactions.h"
#import "DBPlannedTransactions.h"
#import "DBCategory.h"

@interface DatabaseManager : NSObject<NSFetchedResultsControllerDelegate>

+ (DatabaseManager *)getDatabaseManager;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark -
#pragma mark Main Methods
- (void)myInit;
- (void)clearDatabase;

- (void)saveContext;
- (NSString *)applicationDocumentsDirectory;

//Get nsfetchrequet
- (NSFetchRequest *)getRequest: (NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending;

#pragma mark -
#pragma mark Write/Read To/From Database
- (void)writeToDatabase:(NSArray *)dataArray toClass:(Class)toClass fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;
- (id)writeToDatabaseThisObject:(id)object1 toClass:(Class)toClass;

- (NSArray *)readFromDatabase:(NSArray *)dataArray toClass:(Class)toClass;
- (id)readFromDatabaseThisObject:(id)object2 toClass:(Class)toClass;

#pragma mark -
#pragma mark Other
//- (DBUserEmployee *)getLoggedInUser;
//- (DBOrganization *)getLoggedInOrganization;

#pragma mark -
#pragma mark FetchedResultsController
- (void)initFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;
- (void)deleteAllFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;

#pragma mark -
#pragma mark CoreData Helper
- (NSMutableArray *)getObjectsForEntity:(NSString*)entityName withSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending;
- (NSMutableArray *)searchObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending;

- (BOOL)deleteAllObjectsForEntity:(NSString*)entityName;
- (BOOL)deleteObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate;

- (NSUInteger)countForEntity:(NSString *)entityName;
- (NSUInteger)countForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate;

@end
