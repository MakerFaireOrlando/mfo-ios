//
//  Faire+methods.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/16/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "Faire+methods.h"
#import "Maker+methods.h"
#import "Event+methods.h"
#import "NSManagedObject+methods.h"

@implementation Faire (methods)

+ (Faire *)currentFaire
{
    static Faire *currentFaire = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Faire"];
        
        NSPredicate *currentPredicate = [NSPredicate predicateWithFormat:@"current == YES"];
        
        [request setPredicate:currentPredicate];
        
        currentFaire = [[[Faire defaultContext] executeFetchRequest:request error:nil] firstObject];
    });
    
    return currentFaire;
}

+ (void)updateFaire
{
    [Maker updateMakers];
    [Event updateEvents];
}

@end
