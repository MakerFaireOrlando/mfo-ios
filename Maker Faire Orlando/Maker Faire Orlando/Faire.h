//
//  Faire.h
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Maker;

@interface Faire : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * aboutURL;
@property (nonatomic, retain) NSString * volunteerURL;
@property (nonatomic, retain) NSString * attendURL;
@property (nonatomic, retain) NSString * sponsorURL;
@property (nonatomic, retain) NSNumber * current;
@property (nonatomic, retain) NSSet *makers;
@property (nonatomic, retain) NSSet *events;
@end

@interface Faire (CoreDataGeneratedAccessors)

- (void)addMakersObject:(Maker *)value;
- (void)removeMakersObject:(Maker *)value;
- (void)addMakers:(NSSet *)values;
- (void)removeMakers:(NSSet *)values;

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
