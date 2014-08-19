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
#import "DataManager.h"
#import "Photo.h"

@implementation Faire (methods)

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
    //[self updateMaps];
}

+ (void)updateMaps
{
    NSManagedObjectContext *context = [Faire defaultContext];
    
    Faire *currentFaire = [Faire currentFaire];
    
    for (int i = 1; i <= 4; i++) {
        
        NSString *stringMapUrl = [NSString stringWithFormat:@"http://makerfaireorlando.com/images/MFO_OSC_Level%d.jpg", i];
        NSURL *mapURL = [NSURL URLWithString:stringMapUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            NSData *mapData = [NSData dataWithContentsOfURL:mapURL];
            
            Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                                             inManagedObjectContext:context];
            [photo setSourceURL:stringMapUrl];
            [photo setImage:mapData];
                
            [currentFaire addMapsObject:photo];
                
            [context save:nil];
        });
    }
}


@end
