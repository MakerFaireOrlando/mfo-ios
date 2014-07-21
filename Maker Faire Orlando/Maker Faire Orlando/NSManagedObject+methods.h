//
//  NSManagedObject+methods.h
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/18/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (methods)

+ (void)murderTableWithEntityName:(NSString *)entityName;

+ (NSManagedObjectContext *)defaultContext;

@end
