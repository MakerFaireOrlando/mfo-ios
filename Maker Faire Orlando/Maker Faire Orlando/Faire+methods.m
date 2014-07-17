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

@dynamic defaultContext;

+ (Faire *)currentFaire
{
    return nil;
}

+ (void)updateFaire
{
    [Maker updateMakers];
    [Event updateEvents];
}

- (NSManagedObjectContext *)defaultContext
{
    if (self.defaultContext == nil)
    {
        NSManagedObjectContext *context = nil;
        
        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        context = [del managedObjectContext];
        self.defaultContext = context;
    }
    
    return self.defaultContext;
}
@end
