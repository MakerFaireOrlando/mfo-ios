//
//  Faire.h
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/18/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Maker, Photo;

@interface Faire : NSManagedObject

@property (nonatomic, retain) NSString * aboutURL;
@property (nonatomic, retain) NSString * attendURL;
@property (nonatomic, retain) NSNumber * current;
@property (nonatomic, retain) NSString * sponsorURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * volunteerURL;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *makers;
@property (nonatomic, retain) NSSet *maps;
@end

@interface Faire (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addMakersObject:(Maker *)value;
- (void)removeMakersObject:(Maker *)value;
- (void)addMakers:(NSSet *)values;
- (void)removeMakers:(NSSet *)values;

- (void)addMapsObject:(Photo *)value;
- (void)removeMapsObject:(Photo *)value;
- (void)addMaps:(NSSet *)values;
- (void)removeMaps:(NSSet *)values;

@end
