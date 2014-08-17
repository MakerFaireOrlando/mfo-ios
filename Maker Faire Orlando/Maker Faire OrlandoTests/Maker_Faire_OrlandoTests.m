//
//  Maker_Faire_OrlandoTests.m
//  Maker Faire OrlandoTests
//
//  Created by Conner Brooks on 7/15/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "DataManager.h"

@interface Maker_Faire_OrlandoTests : XCTestCase

@property (weak, nonatomic) AppDelegate *del;
@property (weak, nonatomic) NSPersistentStoreCoordinator *storeCoord;
@property (weak, nonatomic) NSManagedObjectContext *context;

@end

@implementation Maker_Faire_OrlandoTests

@synthesize del = _del;
@synthesize storeCoord = _storeCoord;
@synthesize context = _context;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _storeCoord = nil;
    _context = nil;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/**
    Tests whether or not the Database has changed, and is unusable.
 */
- (void)testOpenDatabase
{
    NSPersistentStoreCoordinator *storeCoord = [_del persistentStoreCoordinator];
    
    NSArray *stores = [storeCoord persistentStores];
    NSLog(@"stores: %@", stores);
    
    
    XCTAssertTrue(([stores count] > 0), @"No Persistent Store found.");
    
    _storeCoord = storeCoord;
}

- (void)testOpenDBContext
{
     XCTAssertNotNil([_del managedObjectContext]);
    _context = [_del managedObjectContext];
}

- (void)testDataManagerSingleton
{
    DataManager *testManager = [DataManager sharedDataManager];
    
    XCTAssertTrue([testManager isKindOfClass:[DataManager class]]);
}

- (void)testDataManagerSetup
{
    DataManager *testManager = [DataManager sharedDataManager];
    
    XCTAssertNotNil([testManager session]);
}



@end
