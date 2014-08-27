//
//  CategoriesViewController.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 8/22/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoryTableViewCell.h"
#import "NSManagedObject+methods.h"
#import "Maker.h"


@interface CategoriesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *categories;

- (IBAction)viewTapped:(UITapGestureRecognizer *)sender;
@end

@implementation CategoriesViewController

@synthesize delegate = _delegate;
@synthesize selectedCategories = _selectedCategories;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"willAppear");
    
    [self updateCats];
}

- (void)updateCats
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Maker"];
    [request setPropertiesToFetch:@[@"categories"]];
    [request setReturnsDistinctResults:YES];
    
    NSSortDescriptor *orderAlpha = [NSSortDescriptor sortDescriptorWithKey:@"categories"
                                                                 ascending:YES];
    [request setSortDescriptors:@[orderAlpha]];
    
    NSArray *cats = [[Maker defaultContext] executeFetchRequest:request
                                                          error:nil];
    _categories = nil;
    _categories = [self distinctCatsWithArray:cats];
}

- (NSArray *)distinctCatsWithArray:(NSArray *)array
{
    NSMutableArray *middle = [[NSMutableArray alloc] init];
    
    for (Maker *inner in array)
    {
        NSString *innerCatString = [inner categories];
        
        if (innerCatString != nil)
        {
            NSArray *innerCats = [innerCatString componentsSeparatedByString:@", "];
            
            for (NSString *cat in innerCats)
            {
                if (![middle containsObject:cat] && ![cat isEqualToString:@""])
                {
                    [middle addObject:cat];
                }
            }
        }
    }
    
    return [middle sortedArrayUsingSelector:@selector(compare:)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectedCats];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectedCats];
}

- (void)selectedCats
{
    NSArray *selectedRows = [_tableView indexPathsForSelectedRows];
    
    NSMutableArray *categories = [[NSMutableArray alloc] initWithCapacity:selectedRows.count];
    
    for (NSUInteger i=0; i < selectedRows.count; i++)
    {
        NSIndexPath *indexPath = [selectedRows objectAtIndex:i];
        [categories addObject:[_categories objectAtIndex:indexPath.item]];
    }
    
    [_delegate selectionUpdatedWithCats:categories];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
    [cell setTintColor:[UIColor whiteColor]];
    
    NSString *label = [_categories objectAtIndex:indexPath.item];
    [cell.label setText:label];
    
    if ([_selectedCategories containsObject:label])
    {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (IBAction)viewTapped:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
