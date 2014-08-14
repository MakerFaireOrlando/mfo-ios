//
//  Photo.h
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/16/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * sourceURL;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSManagedObject *maker;

@end
