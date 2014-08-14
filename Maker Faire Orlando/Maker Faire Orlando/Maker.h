//
//  Maker.h
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Faire, Photo;

@interface Maker : NSManagedObject

@property (nonatomic, retain) NSString * categories;
@property (nonatomic, retain) NSString * descript;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * makerName;
@property (nonatomic, retain) NSString * organization;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * videoURL;
@property (nonatomic, retain) NSString * websiteURL;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) Faire *faire;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Maker (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
