//
//  NSManagedObject+methods.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/18/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "NSManagedObject+methods.h"
#import "AppDelegate.h"

@implementation NSManagedObject (methods)

static NSManagedObjectContext *context;

+ (void)murderTableWithEntityName:(NSString *)entityName
{
    NSManagedObjectContext *context = [self defaultContext];
    
    NSFetchRequest *allItems = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [allItems setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    
    NSArray *tableItems = [context executeFetchRequest:allItems
                                                 error:&error];
    
    for (NSManagedObject *item in tableItems)
    {
        [context deleteObject:item];
    }
    
    error = nil;
    
    [context save:&error];
    
    if (error)
    {
        NSLog(@"murder error: %@", error);
    }
}

+ (NSManagedObjectContext *)defaultContext
{
    if (context == nil)
    {
        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        context = [del managedObjectContext];
    }
    
    return context;
}

@end
