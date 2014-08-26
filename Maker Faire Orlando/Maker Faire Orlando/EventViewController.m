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
#import "BOZPongRefreshControl.h"

@interface EventViewController ()

@property (weak, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) BOZPongRefreshControl *refreshControl;
@property (strong, nonatomic) UILabel *failView;

@end

@implementation EventViewController

@synthesize context = _context;
@synthesize events = _events;
@synthesize tableView = _tableView;
@synthesize refreshControl = _refreshControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventsArrived)
                                                 name:kEventsArrived
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshFailure)
                                                 name:kEventsFailed
                                               object:nil];
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _context = [del managedObjectContext];
    
    _events = nil;
    
    [self fillEvents];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        [Event updateEvents];
//    });
}

- (void)viewDidLayoutSubviews
{
    _refreshControl = [BOZPongRefreshControl attachToTableView:_tableView
                                             withRefreshTarget:self
                                              andRefreshAction:@selector(refreshEvents)];

    __block UILabel *failView = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 40.0, 11.0, 80.0, 65.0)];
    [failView setText:@"FAIL"];
    [failView setTextAlignment:NSTextAlignmentCenter];
    [failView setFont:[UIFont boldSystemFontOfSize:35.0]];
    [failView setTextColor:[UIColor whiteColor]];
    [failView setHidden:YES];
    [failView setAlpha:0.0];
    
    _failView = failView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshEvents
{
    [_tableView setUserInteractionEnabled:NO];
    [Event updateEvents];
}

- (void)fillEvents
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    NSSortDescriptor *sortByStartTime = [[NSSortDescriptor alloc] initWithKey:@"startTime"
                                                                    ascending:YES];
    [request setSortDescriptors:@[sortByStartTime]];

    NSString *startDateString = @"13-Sep-14";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yy";
    NSDate *startDate = [dateFormatter dateFromString:startDateString];
    NSString *endDateString = @"15-Sep-14";
    NSDate *endDate = [dateFormatter dateFromString:endDateString];
    
    NSPredicate *filterDate = [NSPredicate predicateWithFormat:@"startTime > %@ AND startTime < %@", startDate, endDate];
    [request setPredicate:filterDate];
    NSArray *returnedEvents = [_context executeFetchRequest:request error:nil];
    
    _events = returnedEvents;
}

- (void)refreshFailure
{
    // The refresh timed-out, failed for some reason, etc
    
    __weak EventViewController *weakSelf = self;
    __weak UILabel *weakFailView = _failView;
    
    [_refreshControl setBackgroundColor:[UIColor blackColor]];
    [_failView setAlpha:0.0];
    [_failView setHidden:YES];
    [_refreshControl addSubview:_failView];
    
    [UIView animateWithDuration:1.0 animations:^(void)
     {
         
         [weakFailView setAlpha:1.0];
         [weakFailView setHidden:NO];
         
         [weakSelf.refreshControl setBackgroundColor:[UIColor makerRed]];
         
     } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.5 animations:^(void)
          {
              [weakFailView removeFromSuperview];
              [weakSelf.refreshControl setBackgroundColor:[UIColor blackColor]];
              
              [weakSelf.refreshControl finishedLoading];
              [weakSelf.tableView setUserInteractionEnabled:YES];
          }];
     }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshControl scrollViewDidEndDragging];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)eventsArrived
{
    [self fillEvents];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_refreshControl finishedLoading];
        [_tableView reloadData];
        [_tableView setUserInteractionEnabled:YES];
    });
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
    NSInteger index = [[_tableView indexPathForSelectedRow] row];
    EventDetailViewController *detailViewController = (EventDetailViewController*)[segue destinationViewController];
    Event *event = [_events objectAtIndex:index];
    [detailViewController setEvent:event];
}

@end
