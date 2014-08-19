//
//  MapContentViewController.h
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;

@property NSUInteger pageIndex;
@property NSData *mapData;

@end
