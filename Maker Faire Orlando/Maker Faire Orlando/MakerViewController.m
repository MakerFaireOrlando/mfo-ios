//
//  FirstViewController.m
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 7/15/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "MakerViewController.h"
#import "AppDelegate.h"
#import "Faire+methods.h"
#import "Maker+methods.h"
#import "makerTableViewCell.h"
#import "MakerDetailViewController.h"

@interface MakerViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSArray *makers;

@property (weak, nonatomic) NSManagedObjectContext *context;
@end

@implementation MakerViewController

@synthesize tableview = _tableview;
@synthesize makers = _makers;
@synthesize context = _context;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(finishRefresh)
                                                     name:kMakersArrived
                                                   object:nil];
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _context = [del managedObjectContext];
	
    [self attemptRefresh];
    
    _makers = nil;
    
    [self fillMakers];
}

- (void)fillMakers
{
    NSFetchRequest *makersFetch = [[NSFetchRequest alloc] initWithEntityName:@"Maker"];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                               ascending:YES];
    [makersFetch setSortDescriptors:@[sortByName]];
    
    NSError *fetchError = nil;
    
    _makers = [_context executeFetchRequest:makersFetch error:&fetchError];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)attemptRefresh
{
    [Faire updateFaire];
}

- (void)finishRefresh
{
    [self fillMakers];
    [_tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _makers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    makerTableViewCell *cell = (makerTableViewCell *)[_tableview dequeueReusableCellWithIdentifier:@"tempMakerCell"];
    
    Maker *cellMaker = [_makers objectAtIndex:indexPath.item];
    
    [cell.textLabel setText:cellMaker.projectName];
    [cell.detailTextLabel setText:cellMaker.location];
    
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    int index = [[_tableview indexPathForSelectedRow] row];
    MakerDetailViewController *detailViewController = (MakerDetailViewController*)[segue destinationViewController];
    NSLog(@"Count: %@", [_makers[index] projectName]);
    Maker *maker = [_makers objectAtIndex:index];
    [detailViewController setMaker:maker];
}


@end
