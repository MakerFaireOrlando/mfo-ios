//
//  DataManager.h
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (strong, atomic) NSURLSession *session;

+ (DataManager *)sharedDataManager;

@end
