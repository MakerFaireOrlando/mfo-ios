//
//  Event+methods.h
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/16/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "Event.h"

@interface Event (methods)

#define kEventsArrived @"com.makerfaireorlando.mfo.eventsarrived"
#define kEventsFailed @"com.makerfaireorlando.mfo.eventsfailedtoarrive"

+ (void)updateEvents;
+ (void)murderEvents;
+ (Event *)parseEventWithDictionary:(NSDictionary *)event;
+ (void)parseEventsWithDictionary:(NSDictionary *)events;

@end
