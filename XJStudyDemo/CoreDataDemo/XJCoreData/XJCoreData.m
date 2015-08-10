//
//  XJCoreData.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/7/29.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJCoreData.h"

@implementation XJCoreData
@synthesize managedObjectContext =_managedObjectContext,managedObjectModel =_managedObjectModel,persistentStoreCoordinator=_persistentStoreCoordinator;
+(XJCoreData *)shareCoreData
{
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:[[self class] description] withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[[self class] description] ]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    //    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    //    {
    //        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    //        abort();
    //    }
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:optionsDictionary
                                                           error:&error]) {
        
        NSLog(@"failed to add persistent store with type to persistent store coordinator");
        
    }
    
    return _persistentStoreCoordinator;
}
/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
////////////////////////***************************************数据库增删改查*******************************////
-(void)saveObjectWithEntityName:(NSString *)entityName managedObjectInfo:(NSManagedObject *)managedObjectinfo primarykey:(NSString *)primarykey
{
    NSArray *arr = nil;
    if (primarykey) {
        NSString* strID = [managedObjectinfo valueForKey:primarykey];
        if (strID)
        {
            arr =[self findObjectFrom:entityName Key:primarykey Value:strID];
        }
    }
    NSManagedObject* obj;
    if (arr && ([arr count] > 0))
    {
        obj = [arr objectAtIndex:0];
    }
    else
    {
        obj = [self insertNewObject:entityName];
        obj = managedObjectinfo;
    }
    
    if (obj)
    {
        [self saveContext];
    }
}
-(NSManagedObject*)insertNewObject:(NSString*)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}
-(NSArray*)fetch:(NSString *)entityName
         sortKey:(NSString *)key
       ascending:(BOOL)asc
       predicate:(NSPredicate*)predicate
{
    //    NSFetchedResultsController* vc = [self fetch:entityName sortKey:key ascending:asc predicate:predicate Delegate:nil];
    //    return [vc fetchedObjects];
    
    // Init a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = nil;
    if (key)
    {
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:asc selector:nil];
        NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
        [fetchRequest setSortDescriptors:descriptors];
    }
    
    if (predicate)
    {
        fetchRequest.predicate = predicate;
    }
    NSError *error;
    NSArray *objects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return objects ;
}

-(NSArray*)findObjectFrom:(NSString *)entityName Key:(NSString*)key Value:(id)value
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:
                              @"%K == %@",key,value];
    
    return [self fetch:entityName
               sortKey:nil
             ascending:NO
             predicate:predicate];
    
}

-(NSArray *)fetchAllObjectsWithEntityName:(NSString *)entityName
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:entityName];
    __autoreleasing NSError *error;
    NSArray *fetchresult=[self.managedObjectContext executeFetchRequest:fetch error:&error];
    return fetchresult;
}

-(void)deleteOneObject:(NSManagedObject *)oneObject
{
    if (oneObject) {
        [self.managedObjectContext deleteObject:oneObject];
    }
    [self saveContext];
}
-(void)deleteAllObjectsWithEntityName:(NSString *)entityName
{
    NSArray *tempArray = [self fetchAllObjectsWithEntityName:entityName];
    if (tempArray && [tempArray count]>0)
    {
        for (NSManagedObject *oneLine in tempArray)
        {
            [self.managedObjectContext deleteObject:oneLine];
        }
    }
    [self saveContext];
}
@end
