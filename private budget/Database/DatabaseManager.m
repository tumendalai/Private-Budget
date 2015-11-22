//
//  DatabaseManager.m
//  XAAH
//
//  Created by Sodtseren on 9/24/12.
//  Copyright (c) 2012 Sodtseren. All rights reserved.
//

#import "DatabaseManager.h"
#import <objc/runtime.h>

@implementation DatabaseManager
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

+ (DatabaseManager *)getDatabaseManager {
    static dispatch_once_t once;
    static DatabaseManager *sharedObject;
    dispatch_once(&once, ^{
        sharedObject = [[DatabaseManager alloc] init];
        [sharedObject myInit];
    });
    return sharedObject;
}

#pragma mark -
#pragma mark Main Methods
- (void) myInit {
	managedObjectContext = self.managedObjectContext;
}
- (void)clearDatabase {
    [DATABASE_MANAGER deleteAllObjectsForEntity:@"DBCategory"];
    [DATABASE_MANAGER deleteAllObjectsForEntity:@"DBCurrency"];
    [DATABASE_MANAGER deleteAllObjectsForEntity:@"DBPlannedTransactions"];
    [DATABASE_MANAGER deleteAllObjectsForEntity:@"DBTransactions"];
}

- (void)saveContext
{
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        }
    }
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Write/Read To/From Database
- (void)writeToDatabase:(NSArray *)dataArray toClass:(Class)toClass fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
    for (id obj in dataArray) {
        [self writeToDatabaseThisObject:obj toClass:toClass];
    }
    if (fetchedResultsController) {
        [self initFetchedResultsController:fetchedResultsController];
    }
}
- (id)writeToDatabaseThisObject:(id)object1 toClass:(Class)toClass {
    
    id object2 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(toClass) inManagedObjectContext:DATABASE_MANAGER.managedObjectContext];
    
    for (NSString *key in [self allPropertyNames:[object1 class]]) {
        if ([object2 respondsToSelector:NSSelectorFromString(key)])
        {
            [object2 setValue:[object1 valueForKey:key] forKey:key];
        }
    }
//    [object2 setValue:[NSDate date] forKey:@"db_inserted_date"];
    
    return object2;
}
- (NSArray *)allPropertyNames:(Class)myClass
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(myClass, &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}
- (NSArray *)readFromDatabase:(NSArray *)dataArray toClass:(Class)toClass {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSManagedObject *managedObject in dataArray) {
        [resultArray addObject:[self readFromDatabaseThisObject:managedObject toClass:toClass]];
    }
    return resultArray;
}
- (id)readFromDatabaseThisObject:(id)object2 toClass:(Class)toClass {
    
    id object1 = [[toClass alloc] init];
    
    for (NSString *key in [self allPropertyNames:[object2 class]]) {
        if ([object1 respondsToSelector:NSSelectorFromString(key)])
        {
            [object1 setValue:[object2 valueForKey:key] forKey:key];
        }
    }
    return object1;
}

#pragma mark -
#pragma mark Other
//- (DBUserEmployee *)getLoggedInUser {
//    NSPredicate *tempPred = [NSPredicate predicateWithFormat:@"isLoginUser == YES"];
//    NSMutableArray *resultArray = [DATABASE_MANAGER searchObjectsForEntity:@"DBUserEmployee" withPredicate:tempPred andSortKey:@"db_inserted_date" andSortAscending:YES];
//    if (resultArray.count > 0) {
//        if (resultArray.count > 1) {
//            DDLogError(@"DATABASE ERROR!!!");
//        }
//        return [resultArray objectAtIndex:0];
//    } else {
//        DDLogError(@"DATABASE ERROR!!!");
//        return nil;
//    }
//}
//- (DBOrganization *)getLoggedInOrganization {
//    NSPredicate *tempPred = [NSPredicate predicateWithFormat:@"isLoginUser == YES"];
//    NSMutableArray *resultArray = [DATABASE_MANAGER searchObjectsForEntity:@"DBOrganization" withPredicate:tempPred andSortKey:@"db_inserted_date" andSortAscending:YES];
//    if (resultArray.count > 0) {
//        if (resultArray.count > 1) {
//            DDLogError(@"DATABASE ERROR!!!");
//        }
//        return [resultArray objectAtIndex:0];
//    } else {
//        DDLogError(@"DATABASE ERROR!!!");
//        return nil;
//    }
//}

#pragma mark -
#pragma mark FetchedResultsController
- (void)initFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
    {
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}
- (void)deleteAllFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
    NSArray *fetchedObjects = [fetchedResultsController fetchedObjects];
	for (NSManagedObject *obj in fetchedObjects) {
		[managedObjectContext deleteObject:obj];
	}
    
	[self initFetchedResultsController:fetchedResultsController];
}

#pragma mark - 
#pragma mark Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"PrivateBudget.sqlite"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"PrivateBudget" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
							 NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
    
    
    //CoreData хувилбар зөрсөн бол өмнөхийг устгах
    {
        NSError *error;
        // Check if we already have a persistent store
        if ( [[NSFileManager defaultManager] fileExistsAtPath:storePath] ) {
            NSDictionary *existingPersistentStoreMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType: NSSQLiteStoreType URL:[NSURL fileURLWithPath:storePath] error: &error];
            if ( !existingPersistentStoreMetadata ) {
                // Something *really* bad has happened to the persistent store
                [NSException raise: NSInternalInconsistencyException format: @"Failed to read metadata for persistent store %@: %@", storePath, error];
            }
            
            if ( ![managedObjectModel isConfiguration: nil compatibleWithStoreMetadata: existingPersistentStoreMetadata] ) {
                if ( ![[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:storePath] error: &error] )
                    NSLog(@"*** Could not delete persistent store, %@", error);
            } // else the existing persistent store is compatible with the current model - nice!
        } // else no database file yet
    }
    
    
    
	NSError *error;
   	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
	
    return persistentStoreCoordinator;
}


//Get nsfetchrequet
- (NSFetchRequest *)getRequest: (NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending {
    // Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
    
	// If a predicate was specified then use it in the request
	if (predicate != nil)
		[request setPredicate:predicate];
    
	// If a sort key was passed then use it in the request
	if (sortKey != nil) {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
	}
    
    return request;
}


#pragma mark -
#pragma mark CoreData Helper
// Fetch objects without a predicate
- (NSMutableArray *)getObjectsForEntity:(NSString*)entityName withSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending
{
	return [self searchObjectsForEntity:entityName withPredicate:nil andSortKey:sortKey andSortAscending:sortAscending];
}
// Fetch objects with a predicate
- (NSMutableArray *)searchObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending
{
	// Execute the fetch request
	NSError *error = nil;
    NSFetchRequest *request = [self getRequest:entityName withPredicate:predicate andSortKey:sortKey andSortAscending:sortAscending];
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
	// If the returned array was nil then there was an error
	if (mutableFetchResults == nil)
		NSLog(@"Couldn't get objects for entity %@", entityName);
    
	// Return the results
	return mutableFetchResults;
}
// Delete objects with a predicate
-(BOOL)deleteObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
    
	[request setIncludesPropertyValues:NO];
    
	if (predicate != nil)
		[request setPredicate:predicate];
    
	NSError *error = nil;
	NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    
	// Delete the objects returned if the results weren't nil
	if (fetchResults != nil && error == nil) {
		for (NSManagedObject *manObj in fetchResults) {
			[self.managedObjectContext deleteObject:manObj];
		}
	} else {
		NSLog(@"Couldn't delete objects for entity %@", entityName);
		return NO;
	}
    
	return YES;
}

// Delete all objects for a given entity
- (BOOL)deleteAllObjectsForEntity:(NSString*)entityName
{
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
    
    [request setFetchBatchSize:200];
    
	// Ignore property values for maximum performance
	[request setIncludesPropertyValues:NO];
    
	// Execute the count request
	NSError *error = nil;
	NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    
	// Delete the objects returned if the results weren't nil
	if (fetchResults != nil) {
		for (NSManagedObject *manObj in fetchResults) {
			[self.managedObjectContext deleteObject:manObj];
		}
	} else {
		NSLog(@"Couldn't delete objects for entity %@", entityName);
		return NO;
	}
    
	return YES;
}

#pragma mark -
#pragma mark Count objects

// Get a count for an entity with a predicate
- (NSUInteger)countForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	[request setIncludesPropertyValues:NO];
    
	// If a predicate was specified then use it in the request
	if (predicate != nil)
		[request setPredicate:predicate];
    
	// Execute the count request
	NSError *error = nil;
	NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    
	// If the count returned NSNotFound there was an error
	if (count == NSNotFound)
		NSLog(@"Couldn't get count for entity %@", entityName);
    
	// Return the results
	return count;
}

// Get a count for an entity without a predicate
- (NSUInteger)countForEntity:(NSString *)entityName
{
	return [self countForEntity:entityName withPredicate:nil];
}

@end
