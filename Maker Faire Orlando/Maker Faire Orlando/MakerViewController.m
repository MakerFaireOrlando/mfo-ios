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

@interface MakerViewController () <CategoryDelegate, NSFetchedResultsControllerDelegate, UIViewControllerAnimatedTransitioning>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

//@property (strong, nonatomic) NSArray *makers;
//@property (strong, nonatomic) NSMutableArray *filteredMakers;
@property (strong, nonatomic) NSPredicate *filteringPredicate;
@property (strong, nonatomic) NSMutableArray *categoriesPredicates;
@property (strong, nonatomic) NSArray *categoriesPicked;

@property (weak, nonatomic) IBOutlet UISearchBar *makerSearchBar;
@property (weak, nonatomic) BOZPongRefreshControl *refreshControl;
@property (strong, nonatomic) UILabel *failView;

@property (weak, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) CategoryTransitionAnimator *animator;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation MakerViewController

@synthesize tableview = _tableview;
@synthesize context = _context;
@synthesize failView = _failView;
@synthesize animator = _animator;

#pragma mark – Init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _context = [del managedObjectContext];
    
    NSError *initialFetchError = nil;
    [self.fetchedResultsController performFetch:&initialFetchError];
    
    if (initialFetchError)
    {
        NSLog(@"initial fetch error: %@", initialFetchError);
    }
    
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
	
    [self attemptRefresh];
}

- (void)viewDidLayoutSubviews
{
    _refreshControl = [BOZPongRefreshControl attachToTableView:_tableview
                                             withRefreshTarget:self
                                              andRefreshAction:@selector(disableForRefresh)];
    UILabel *failView = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 40.0, 11.0, 80.0, 65.0)];
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
    
    _fetchedResultsController = nil;
}

#pragma mark - ScrollView Protocol

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshControl scrollViewDidEndDragging];
}

#pragma mark - Refresh Methods

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
    __weak MakerViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.refreshControl finishedLoading];
        [weakSelf.tableview reloadData];
        [weakSelf.tableview setUserInteractionEnabled:YES];
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

#pragma mark - TableView DataSource/Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
    Maker *makerForCell = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell.textLabel setText:makerForCell.projectName];
    
    if ([makerForCell.location isEqualToString:@""] || makerForCell.location == nil)
    {
        [cell.detailTextLabel setText:@"TBD"];
    }
    else
    {
        [cell.detailTextLabel setText:makerForCell.location];
    }
}

#pragma mark - Segues and ViewController animations

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    makerTableViewCell *cell = (makerTableViewCell *)[_tableview dequeueReusableCellWithIdentifier:@"tempMakerCell"];
    
    [self configureCell:cell
            atIndexPath:indexPath];
    
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
        
        Maker *maker = [self.fetchedResultsController objectAtIndexPath:[_tableview indexPathForSelectedRow]];
        
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

#pragma mark - Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    // clear filter predicate
    _filteringPredicate = nil;

    // Add the filter
    
    _filteringPredicate = [NSPredicate predicateWithFormat:@"SELF.projectName contains[c] %@",searchText];
    
    if (_categoriesPredicates != nil && [_categoriesPredicates count] > 0)
    {
        NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[_categoriesPredicates, _filteringPredicate]];
        [_fetchedResultsController.fetchRequest setPredicate:compoundPredicate];
    }
    else
    {
        [_fetchedResultsController.fetchRequest setPredicate:_filteringPredicate];
    }
}

- (void)selectionUpdatedWithCats:(NSArray *)categories
{
    _categoriesPicked = categories;
    
    if (_categoriesPicked.count == 0)
    {
        [_fetchedResultsController.fetchRequest setPredicate:nil];
    }
    else
    {
        NSMutableArray *catPredicates = [NSMutableArray arrayWithCapacity:[_categoriesPicked count]];
        
        for (NSString *cat in _categoriesPicked)
        {
            NSPredicate *currentPartPredicate = [NSPredicate predicateWithFormat:@"SELF.categories contains[c] %@", cat];
            [catPredicates addObject:currentPartPredicate];
        }
        
        NSPredicate *fullPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:catPredicates];
        
        [_fetchedResultsController.fetchRequest setPredicate:fullPredicate];
    }
    
    [_fetchedResultsController performFetch:nil];
    [_tableview reloadData];
    
//    _filteredMakers = [NSMutableArray arrayWithArray:[_makers filteredArrayUsingPredicate:fullPredicate]];
    
//    [_tableview reloadData];
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

#pragma mark - NSFetchedResultsControllerDelegate methods

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *makersFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Maker"];
    
    NSSortDescriptor *sortByLocation = [[NSSortDescriptor alloc] initWithKey:@"location"
                                                                   ascending:YES];
    
    [makersFetchRequest setSortDescriptors:@[sortByLocation]];
    
    [makersFetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFRC;
    theFRC = [[NSFetchedResultsController alloc] initWithFetchRequest:makersFetchRequest
                                                 managedObjectContext:_context
                                                   sectionNameKeyPath:@"location"
                                                            cacheName:nil];
    _fetchedResultsController = theFRC;
    [_fetchedResultsController setDelegate:self];
    
    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    __weak UITableView *weakTableView = _tableview;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [weakTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [weakTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            UITableViewCell *cell = [weakTableView cellForRowAtIndexPath:indexPath];
            if (cell != nil)
            {
                [self configureCell:cell
                        atIndexPath:newIndexPath];
            }}
            break;
            
        case NSFetchedResultsChangeMove:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                
                [weakTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
            });
            break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
        {
            [_tableview insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [_tableview deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationFade];

            break;
        }
        case NSFetchedResultsChangeMove:
        {
//            _tableview moveSection:<#(NSInteger)#> toSection:<#(NSInteger)#>
            
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            break;
        }
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [_tableview beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [_tableview endUpdates];
}

@end
