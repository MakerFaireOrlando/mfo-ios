//
//  MapContentViewController.m
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "MapContentViewController.h"

@implementation MapContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapImageView.image = [UIImage imageWithData:self.mapData];
}

@end
