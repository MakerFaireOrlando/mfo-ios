//
//  DataManager.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()

@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfig;

@end

@implementation DataManager

+ (DataManager *)sharedDataManager
{
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
        [sharedInstance setup];
    });
    
    return sharedInstance;
}

- (void)setup
{
    
}

@end
