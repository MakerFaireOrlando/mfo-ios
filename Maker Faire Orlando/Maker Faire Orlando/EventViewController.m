//
//  SecondViewController.m
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 7/15/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "EventViewController.h"
#import "AppDelegate.h"
#import "Event+methods.h"
#import "EventTableViewCell.h"

@interface EventViewController ()

@property (weak, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EventViewController

@synthesize context = _context;
@synthesize events = _events;
@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventsArrived)
                                                 name:kEventsArrived
                                               object:nil];
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _context = [del managedObjectContext];
    
    _events = nil;
    
    [self fillEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fillEvents
{
    [Event updateEvents];
}

- (void)eventsArrived
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    NSSortDescriptor *sortByStartTime = [[NSSortDescriptor alloc] initWithKey:@"startTime"
                                                                    ascending:YES];
    [request setSortDescriptors:@[sortByStartTime]];
    
    NSArray *returnedEvents = [_context executeFetchRequest:request error:nil];
    
    _events = returnedEvents;
    
    [_tableView reloadData];
    
    //TODO: End refreshing
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _events.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"tempEventCell"];
    
    Event *event = [_events objectAtIndex:indexPath.item];
    
    [cell.tempLabel setText:event.summary];
    
    return cell;
}

@end
