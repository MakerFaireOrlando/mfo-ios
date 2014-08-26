//
//  CategoryTransitionAnimator.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 8/18/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "CategoryTransitionAnimator.h"
#import "MakerViewController.h"

@implementation CategoryTransitionAnimator

@synthesize presenting = _presenting;

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    float offsetWidth = 250.0f;
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
//    CGRect endFrame = CGRectMake(80, 280, 160, 100);
    CGRect endFrame = CGRectMake(0,
                                 0,
                                 offsetWidth,
                                 screenHeight);
    
    if (_presenting)
    {
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        startFrame.origin.x = screenWidth;
        
        toViewController.view.frame = startFrame;
        __block UIView *mask = [toViewController.view viewWithTag:42];
        [mask setAlpha:0.0f];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0f
             usingSpringWithDamping:0.5f
              initialSpringVelocity:0.05f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
        {
            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            [fromViewController.view setUserInteractionEnabled:NO];
            
            [mask setAlpha:1.0f];
            
            toViewController.view.frame = endFrame;
            
        }
                         completion:^(BOOL finished)
        {
            [transitionContext completeTransition:YES];
        }];
    }
    else
    {
        endFrame.origin.x += screenWidth;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0f
             usingSpringWithDamping:0.5f
              initialSpringVelocity:0.05f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
        {
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [fromViewController.view setFrame:endFrame];
        }
                         completion:^(BOOL finished)
        {
            [toViewController.view setUserInteractionEnabled:YES];
            [transitionContext completeTransition:YES];
        }];
        
//        [UIView animateWithDuration:[self transitionDuration:transitionContext]
//                         animations:^
//        {
//            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
//            [fromViewController.view setFrame:endFrame];
//        }
//                         completion:^(BOOL finished)
//        {
//            [transitionContext completeTransition:YES];
//        }];
        
        
    }
}

@end
