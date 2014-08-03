//
//  Event.h
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/16/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Faire;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * descript;
@property (nonatomic, retain) Faire *faire;

@end
