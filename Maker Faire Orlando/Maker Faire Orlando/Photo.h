//
//  Photo.h
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/18/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Faire, Maker;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * sourceURL;
@property (nonatomic, retain) Maker *maker;
@property (nonatomic, retain) Faire *faire;

@end
