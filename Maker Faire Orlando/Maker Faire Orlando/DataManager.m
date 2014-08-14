//
//  DataManager.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "DataManager.h"

@interface DataManager () <NSURLSessionDelegate>

@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfig;

@end

@implementation DataManager

@synthesize session = _session;
@synthesize sessionConfig = _sessionConfig;

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
    _sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    _sessionConfig.allowsCellularAccess = YES;
    [_sessionConfig setHTTPAdditionalHeaders:@{@"Accept":@"application/json"}];
    
    _sessionConfig.timeoutIntervalForRequest = 20.0f;
    _sessionConfig.timeoutIntervalForResource = 40.0f;
    _sessionConfig.HTTPMaximumConnectionsPerHost = 4;
    
    _session = [NSURLSession sessionWithConfiguration:_sessionConfig delegate:self delegateQueue:nil];
}

@end
