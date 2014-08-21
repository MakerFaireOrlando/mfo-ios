//
//  MapImageViewController.m
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/21/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "MapImageViewController.h"

@implementation MapImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapImageView.userInteractionEnabled = YES;
    
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]
                               initWithTarget:self action:@selector(pinchGestureDetected:)];
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                             initWithTarget:self action:@selector(panGestureDetected:)];
    
    _mapImageView.image = [UIImage imageWithData:_mapPhoto.image];
    
    [_panGestureRecognizer setDelegate:self];
    _pinchGestureRecognizer.delegate = self;
    
    [_mapImageView addGestureRecognizer:_pinchGestureRecognizer];
    [_mapImageView addGestureRecognizer:_panGestureRecognizer];
    
    self.view.backgroundColor = [UIColor blackColor];
}


- (void)pinchGestureDetected:(UIPinchGestureRecognizer *)recognizer
{
    /*UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, scale, scale)];
        [recognizer setScale:1.0];
    }*/
    
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
    
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        [recognizer.view setTransform:CGAffineTransformTranslate(recognizer.view.transform, translation.x, translation.y)];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
