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
    
    // retreive image based on index then cache it in orm
    //NSManagedObjectContext *context = [Faire defaultContext];
    
    _mapImageView.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(pinchGestureDetected:)];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(panGestureDetected:)];
    [panGestureRecognizer setDelegate:self];
    
    pinchGestureRecognizer.delegate = self;
    [_mapImageView addGestureRecognizer:pinchGestureRecognizer];
    [_mapImageView addGestureRecognizer:panGestureRecognizer];
    
    /*
     How this should work is when we load this view check and see if the photo at the index is already in the maps set on the 
     current faire then if it is load that version otherwise dowload it and add it to the faire. We need to be able to access images
     by index 1-4.
     */
    
    NSString *stringMapUrl = [NSString stringWithFormat:@"http://makerfaireorlando.com/images/MFO_OSC_Level%d.jpg", _pageIndex + 1];
    NSURL *mapURL = [NSURL URLWithString:stringMapUrl];
        
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        NSData *mapData = [NSData dataWithContentsOfURL:mapURL];
                           
        //Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        //[photo setSourceURL:stringMapUrl];
        //[photo setImage:mapData];
                           
        //[currentFaire addMapsObject:photo];
                           
        //[context save:nil];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            // Back to the main thread for UI updates, etc.
            self.mapImageView.image = [UIImage imageWithData:mapData];
        });
    });
}

- (void)pinchGestureDetected:(UIPinchGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, scale, scale)];
        [recognizer setScale:1.0];
    }
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



@end
