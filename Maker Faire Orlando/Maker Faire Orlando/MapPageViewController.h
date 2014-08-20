//
//  MapPageViewController.h
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapPageViewController : UIPageViewController <UIPageViewControllerDataSource>

#define numPictures 4

@property (strong, nonatomic) NSArray *pageImages;

@end
