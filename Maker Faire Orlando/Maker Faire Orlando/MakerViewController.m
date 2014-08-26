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
#import "BOZPongRefreshControl.h"
#import "CategoryTransitionAnimator.h"
#import "CategoriesViewController.h"

@interface MakerViewController () <CategoryDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSArray *makers;
@property (strong, nonatomic) NSMutableArray *filteredMakers;
@property (strong, nonatomic) NSArray *categoriesPicked;

@property (weak, nonatomic) IBOutlet UISearchBar *makerSearchBar;
@property (weak, nonatomic) BOZPongRefreshControl *refreshControl;
@property (strong, nonatomic) UILabel *failView;

@property (weak, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) CategoryTransitionAnimator *animator;
@end

@implementation MakerViewController

@synthesize tableview = _tableview;
@synthesize makers = _makers;
@synthesize context = _context;
@synthesize failView = _failView;
@synthesize animator = _animator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _animator = [[CategoryTransitionAnimator alloc] init];
    
    _makerSearchBar.barTintColor = [UIColor makerRed];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishRefresh)
                                                 name:kMakersArrived
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshFailure)
                                                 name:kMakersFailed
                                               object:nil];
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _context = [del managedObjectContext];
	
    [self attemptRefresh];
    
    _makers = nil;
    
    [self fillMakers];
}

- (void)viewDidLayoutSubviews
{
    _refreshControl = [BOZPongRefreshControl attachToTableView:_tableview
                                             withRefreshTarget:self
                                              andRefreshAction:@selector(disableForRefresh)];
    __block UILabel *failView = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 40.0, 11.0, 80.0, 65.0)];
    [failView setText:@"FAIL"];
    [failView setTextAlignment:NSTextAlignmentCenter];
    [failView setFont:[UIFont boldSystemFontOfSize:35.0]];
    [failView setTextColor:[UIColor whiteColor]];
    [failView setHidden:YES];
    [failView setAlpha:0.0];

    _failView = failView;
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

- (void)disableForRefresh
{
    [_tableview setUserInteractionEnabled:NO];
    [self attemptRefresh];
}

- (void)attemptRefresh
{
    [Maker updateMakers];
}

- (void)finishRefresh
{
    [self fillMakers];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_refreshControl finishedLoading];
        [_tableview reloadData];
        [_tableview setUserInteractionEnabled:YES];
    });
}

- (void)refreshFailure
{
    // The refresh timed-out, failed for some reason, etc
    
    __weak MakerViewController *weakSelf = self;
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
             [weakSelf.tableview setUserInteractionEnabled:YES];
         }];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView || (_categoriesPicked != nil && _categoriesPicked.count > 0))
    {
        return [_filteredMakers count];
    } else {
        return [_makers count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    makerTableViewCell *cell = (makerTableViewCell *)[_tableview dequeueReusableCellWithIdentifier:@"tempMakerCell"];
    
    Maker *cellMaker;
    
    if (tableView == self.searchDisplayController.searchResultsTableView || (_categoriesPicked != nil && _categoriesPicked.count > 0))
    {
        NSLog(@"indexPath: %ld", (long)indexPath.item);
        cellMaker = [_filteredMakers objectAtIndex:indexPath.item];
    } else {
        cellMaker = [_makers objectAtIndex:indexPath.item];
    }
    
    [cell.textLabel setText:cellMaker.projectName];
    [cell.detailTextLabel setText:cellMaker.location];
    
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([[segue identifier] isEqualToString:@"showCategories"])
    {
        NSLog(@"showCategories");
        
        CategoriesViewController *destController = (CategoriesViewController *)segue.destinationViewController;
        
        [destController setSelectedCategories:_categoriesPicked];
        
        [destController setDelegate:self];
        
        [destController setTransitioningDelegate:self];
        [destController setModalPresentationStyle:UIModalPresentationCustom];
        
    }
    else
    {
        MakerDetailViewController *detailViewController = (MakerDetailViewController*)[segue destinationViewController];
        
        Maker *maker = nil;
        if(self.searchDisplayController.active) {
            NSInteger row = [[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow] row];
            maker = [_filteredMakers objectAtIndex:row];
        }
        else {
            NSInteger row = [[_tableview indexPathForSelectedRow] row];
            maker = [_makers objectAtIndex:row];
        }
        
        [detailViewController setMaker:maker];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    [_animator setPresenting:YES];
    
    return _animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    [_animator setPresenting:NO];
    return _animator;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // clear filter array
    [_filteredMakers removeAllObjects];
    // Filter the array
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.projectName contains[c] %@",searchText];
    _filteredMakers = [NSMutableArray arrayWithArray:[_makers filteredArrayUsingPredicate:predicate]];
}

- (void)selectionUpdatedWithCats:(NSArray *)categories
{
    _categoriesPicked = categories;
    
    NSMutableArray *catPredicates = [NSMutableArray arrayWithCapacity:[_categoriesPicked count]];
    
    for (NSString *cat in _categoriesPicked)
    {
        NSPredicate *currentPartPredicate = [NSPredicate predicateWithFormat:@"SELF.categories contains[c] %@", cat];
        [catPredicates addObject:currentPartPredicate];
    }
    
    NSPredicate *fullPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:catPredicates];

    _filteredMakers = [NSMutableArray arrayWithArray:[_makers filteredArrayUsingPredicate:fullPredicate]];
    
    [_tableview reloadData];
}

- (void)clearCategories
{
    NSLog(@"clear categories");
    
    _categoriesPicked = nil;
    
    [_tableview reloadData];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // should reload on change
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to reload table view
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to reload table view
    return YES;
}


@end
