//
//  MapContentViewController.m
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "MapContentViewController.h"
#import "NSManagedObject+methods.h"


@implementation MapContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tapped = false;
    
    _mapImageView.userInteractionEnabled = YES;
    
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(pinchGestureDetected:)];
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(panGestureDetected:)];
    _singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    
    _singleTapRecognizer.numberOfTapsRequired = 1;
    
    [_panGestureRecognizer setDelegate:self];
    _pinchGestureRecognizer.delegate = self;
    
    
    [_mapImageView addGestureRecognizer:_singleTapRecognizer];
    
    
    
    Faire *currentFaire = [Faire currentFaire];
    
    NSManagedObjectContext *context = [Faire defaultContext];
    
    dispatch_queue_t imageQueue = dispatch_queue_create("com.makerfaireorlando.FaireImageQueue",NULL);
    
    NSString *stringMapUrl = [NSString stringWithFormat:@"http://makerfaireorlando.com/images/MFO_OSC_Level%d.jpg", _pageIndex + 1];
    NSURL *mapURL = [NSURL URLWithString:stringMapUrl];
    
    if (_mapPhoto == nil)
    {
        dispatch_async(imageQueue, ^(void)
        {
                       
            NSData *mapData = [NSData dataWithContentsOfURL:mapURL];
                       
            Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                                                    inManagedObjectContext:context];
                       
            [photo setSourceURL:stringMapUrl];
            [photo setImage:mapData];
                       
            [currentFaire addMapsObject:photo];
                       
            [context save:nil];
                       
            dispatch_async(dispatch_get_main_queue(), ^{
                self.mapImageView.image = [UIImage imageWithData:mapData];
                self.mapPhoto = photo;
            });
        });
    }
    else
    {
        _mapImageView.image = [UIImage imageWithData:_mapPhoto.image];
    }
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


// Tap the picture in order to pin and pan
// so that the pageview will work
-(void)tapDetected{
    _tapped = !_tapped;
    
    if (_tapped)
    {
        [_mapImageView addGestureRecognizer:_pinchGestureRecognizer];
        [_mapImageView addGestureRecognizer:_panGestureRecognizer];
    }
    else{
        [_mapImageView removeGestureRecognizer:_pinchGestureRecognizer];
        [_mapImageView removeGestureRecognizer:_panGestureRecognizer];
    }
}



@end
