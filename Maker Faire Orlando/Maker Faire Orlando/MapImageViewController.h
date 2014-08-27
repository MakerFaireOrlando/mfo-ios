//
//  MapImageViewController.h
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/21/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface MapImageViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;

@property Photo *mapPhoto;

@property UIPinchGestureRecognizer *pinchGestureRecognizer;
@property UIPanGestureRecognizer *panGestureRecognizer;

@end
