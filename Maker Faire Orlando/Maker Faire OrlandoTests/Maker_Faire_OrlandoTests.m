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
#import "Event+methods.h"

@interface Maker_Faire_OrlandoTests : XCTestCase

@property (weak, nonatomic) AppDelegate *del;
@property (weak, nonatomic) NSPersistentStoreCoordinator *storeCoord;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSData *eventJSON;
@property (strong, nonatomic) NSArray *eventsArray;

@end

@implementation Maker_Faire_OrlandoTests

@synthesize del = _del;
@synthesize storeCoord = _storeCoord;
@synthesize context = _context;
@synthesize eventJSON = _eventJSON;
@synthesize eventsArray = _eventsArray;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _storeCoord = nil;
    _context = [_del managedObjectContext];
    
    NSBundle *mainBundle = [NSBundle bundleWithIdentifier:@"com.makerfaireorlando.Maker-Faire-OrlandoTests"];
    
    NSString *eventsJSONFilePath = [mainBundle pathForResource:@"eventsTest" ofType:@"json"];
    
    NSString *eventsString = [NSString stringWithContentsOfFile:eventsJSONFilePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    
    _eventJSON = [eventsString dataUsingEncoding:NSUTF8StringEncoding];
    
    _eventsArray = [[NSJSONSerialization JSONObjectWithData:_eventJSON
                                                    options:0
                                                      error:nil] objectForKey:@"items"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    _eventJSON = nil;
    _eventsArray = nil;
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
    XCTAssertNotNil(_context);
}

- (void)testDataManagerSetup
{
    DataManager *testManager = [DataManager sharedDataManager];
    
    XCTAssertNotNil([testManager session]);
}

- (void)testSessionSetup
{
    NSURLSession *session = [[DataManager sharedDataManager] session];
    
    XCTAssertNotNil(session, @"NSURLSession returned nil, check the session config");
}

- (void)testParseEvent
{
    NSDictionary *singleEvent = [_eventsArray objectAtIndex:0];
    
    Event *parsedEvent = [Event parseEventWithDictionary:singleEvent];
    
    if (parsedEvent == nil)
    {
        XCTFail(@"parsedEvent was Nil.  Theoretically we shouldn't have gotten this far...");
    }
    
    if (![[parsedEvent summary] isEqualToString:@"Orlando Mini Maker Faire - The Fun Begins!!"])
    {
        XCTFail(@"Failed to parse Summary");
    }
    
    NSLog(@"startTime: %@", [[parsedEvent startTime] description]);
    
    NSMutableString *startDateMutable = [@"2013-10-05T10:00:00-04:00" mutableCopy];
    NSMutableString *endDateMutable = [@"2013-10-05T10:00:00-04:00" mutableCopy];
    
    [startDateMutable deleteCharactersInRange:NSMakeRange(startDateMutable.length - 3, 1)];
    [endDateMutable deleteCharactersInRange:NSMakeRange(endDateMutable.length - 3, 1)];
    
    NSDateFormatter *dateConverter = [[NSDateFormatter alloc] init];
    [dateConverter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSDate *startDate = [dateConverter dateFromString:startDateMutable];
    NSDate *endDate = [dateConverter dateFromString:endDateMutable];
    
    if (![[parsedEvent startTime] isEqualToDate:startDate])
    {
        XCTFail(@"Failed to parse StartDate");
    }
    
    if (![[parsedEvent endTime] isEqualToDate:endDate])
    {
        XCTFail(@"Failed to parse EndDate");
    }
    
    [_context deleteObject:parsedEvent];
}

- (void)testParseEvents
{
    NSDictionary *localEvents = [NSJSONSerialization JSONObjectWithData:_eventJSON
                                                                options:0
                                                                  error:nil];
    
    [Event parseEventsWithDictionary:localEvents];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    
    NSArray *Events = [_context executeFetchRequest:request
                                              error:nil];
    
    XCTAssertEqual([Events count], 25, @"Not all the events made it into the database");
}

- (void)testMurderEvents
{
    [Event murderEvents];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    NSArray *events = [_context executeFetchRequest:request
                                              error:nil];
    XCTAssertEqual([events count], 0, @"Failed to remove all events from the table");
}

@end
