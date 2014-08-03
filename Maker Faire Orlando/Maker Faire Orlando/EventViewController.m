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
#import "EventDetailViewController.h"

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
    
    [cell.textLabel setText:event.summary];
    [cell.detailTextLabel setText:event.location];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    int index = [[_tableView indexPathForSelectedRow] row];
    EventDetailViewController *detailViewController = (EventDetailViewController*)[segue destinationViewController];
    Event *event = [_events objectAtIndex:index];
    [detailViewController setEvent:event];
}

@end
