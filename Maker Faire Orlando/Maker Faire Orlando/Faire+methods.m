//
//  Faire+methods.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/16/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "Faire+methods.h"
#import "AppDelegate.h"
#import "Maker+methods.h"
#import "Event+methods.h"

@implementation Faire (methods)

static NSManagedObjectContext *context;

+ (Faire *)currentFaire
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Faire"];
    
    NSPredicate *currentPredicate = [NSPredicate predicateWithFormat:@"current == YES"];
    
    [request setPredicate:currentPredicate];
    
    Faire *current = [[[Faire defaultContext] executeFetchRequest:request error:nil] firstObject];
    
    return current;
}

+ (void)updateFaire
{
    [Maker updateMakers];
    [Event updateEvents];
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
