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
    MakerViewController *fromViewController = (MakerViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
//    CGRect endFrame = CGRectMake(80, 280, 160, 100);
    CGRect endFrame = CGRectMake(fromViewController.view.frame.size.width-250.0, 0, 250.0, fromViewController.view.frame.size.height);
    
    if (_presenting)
    {
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        startFrame.origin.x = fromViewController.view.frame.size.width;
        
        toViewController.view.frame = startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else
    {
        
    }
}

@end
