//
//  Event+methods.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/16/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "Event+methods.h"
#import "DataManager.h"
#import "Faire+methods.h"
#import "NSManagedObject+methods.h"

#define kEventsURL @"https://www.googleapis.com/calendar/v3/calendars/orlandominimakerfaire.com_vffhp2b6oi3kiu3trnoo1502hg@group.calendar.google.com/events?key="
#define kEventsKey @"AIzaSyApmGbYssXVQ0_BM-UyC7UiVvfO6AS9soo"

@interface Event ()

@end

@implementation Event (methods)

+ (void)updateEvents
{
    NSURL *eventsURL = [NSURL URLWithString:[kEventsURL stringByAppendingString:kEventsKey]];
    
    __weak NSURLSession *session = [[DataManager sharedDataManager] session];
    
    NSURLSessionDataTask *eventsDownloadTask = [session dataTaskWithURL:eventsURL completionHandler:eventsDownloadResponse];
    
    [eventsDownloadTask resume];
}

void (^eventsDownloadResponse)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error)
{
    NSLog(@"events response: %@", response.description);
    
    NSString *notif = nil;

    if (error)
    {
        notif = kEventsFailed;
    }
    else
    {
        notif = kEventsArrived;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        NSArray *eventsArray = [dict objectForKey:@"items"];
        
        // Let's just torch everything since it's a small set of data (for now)
        
        if (eventsArray.count > 0)
        {
            [Event murderEvents];
            [Event parseEventsWithArray:eventsArray];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notif object:nil];
};

+ (void)murderEvents
{
    [NSManagedObject murderTableWithEntityName:[[self class] description]];
}

+ (void)parseEventsWithArray:(NSArray *)events
{
    NSManagedObjectContext *context = [Event defaultContext];
    Faire *currentFaire = [Faire currentFaire];
    
    for (NSDictionary *event in events)
    {
        Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                        inManagedObjectContext:context];
        
        [newEvent setFaire:currentFaire];
        [currentFaire addEventsObject:newEvent];
        NSLog(@"event.start: %@", [event objectForKey:@"start"]);
        NSLog(@"dateTime = %@", [[[event objectForKey:@"start"] objectForKey:@"dateTime"] class]);
        
        NSString *startDateString = [[event objectForKey:@"start"] objectForKey:@"dateTime"];
        NSString *endDateString = [[event objectForKey:@"end"] objectForKey:@"dateTime"];
        NSMutableString *startDateMutable = [startDateString mutableCopy];
        NSMutableString *endDateMutable = [endDateString mutableCopy];
        
        [startDateMutable deleteCharactersInRange:NSMakeRange(startDateMutable.length - 3, 1)];
        [endDateMutable deleteCharactersInRange:NSMakeRange(endDateMutable.length - 3, 1)];
        
        NSDateFormatter *dateConverter = [[NSDateFormatter alloc] init];
        [dateConverter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        
        NSDate *startDate = [dateConverter dateFromString:startDateMutable];
        NSDate *endDate = [dateConverter dateFromString:endDateMutable];
        
        [newEvent setStartTime:startDate];
        [newEvent setEndTime:endDate];
        
        NSString *location = [event objectForKey:@"location"];
        if (location != nil && ![location isEqualToString:@""])
        {
            [newEvent setLocation:location];
        }
        
        NSString *summary = [event objectForKey:@"summary"];
        if (summary != nil && ![summary isEqualToString:@""])
        {
            [newEvent setSummary:summary];
        }
        
    
        NSString *descript = [event objectForKey:@"description"];
        if(descript != nil && ![descript isEqualToString:@""])
        {
            [newEvent setDescript:descript];
        }
       
    }
    [context save:nil];
}
@end
