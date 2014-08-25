//
//  MapPageViewController.m
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "MapPageViewController.h"
#import "Faire+methods.h"
#import "MapContentViewController.h"
#import "Photo.h"
#import "NSManagedObject+methods.h"

@implementation MapPageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.view.backgroundColor = [UIColor whiteColor];

    self.dataSource = self;
    self.view.backgroundColor = [UIColor makerBlue];
    
    Faire *currentFaire = [Faire currentFaire];
    
    if ([currentFaire maps] != nil)
    {
        _pageImages = [[currentFaire maps] allObjects];
    }
    
    MapContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((MapContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((MapContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == numPictures) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (MapContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ((numPictures == 0) || (index >= numPictures)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    MapContentViewController *mapContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapContentViewController"];

    // If core data has the images and they are available use those
    // TODO: add a way to refresh pictures
    if(_pageImages != nil)
    {
        for (Photo *photo in _pageImages)
        {
            NSString *stringMapUrl = [NSString stringWithFormat:@"http://makerfaireorlando.com/images/MFO_OSC_Level%d.jpg", index + 1];
            if ([photo.sourceURL isEqualToString:stringMapUrl])
            {
                mapContentViewController.mapPhoto = photo;
            }
        }
    }
    
    mapContentViewController.pageIndex = index;
    
    return mapContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 4;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
