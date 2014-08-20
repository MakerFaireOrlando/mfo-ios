//
//  MapContentViewController.h
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "Faire+methods.h"

@interface MapContentViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;


@property NSUInteger pageIndex;
@property Photo *mapPhoto;
@property BOOL tapped;

@property UIPinchGestureRecognizer *pinchGestureRecognizer;
@property UIPanGestureRecognizer *panGestureRecognizer;
@property UITapGestureRecognizer *singleTapRecognizer;


@end
