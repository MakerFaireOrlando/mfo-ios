//
//  MapContentViewController.m
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "MapContentViewController.h"
#import "NSManagedObject+methods.h"
#import "MapImageViewController.h"


@implementation MapContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tapped = false;
    
    _mapImageView.userInteractionEnabled = YES;
    
    _singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    
    _singleTapRecognizer.numberOfTapsRequired = 1;
    
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
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
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
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
        });
    }
    else
    {
        _mapImageView.image = [UIImage imageWithData:_mapPhoto.image];
    }
}




// Tap the picture in order to pin and pan
// so that the pageview will work
-(void)tapDetected{
    MapImageViewController *mapImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapImageViewController"];
    
    //mapContentViewController
    
    mapImageViewController.mapPhoto = _mapPhoto;
    
    [self.navigationController pushViewController:mapImageViewController animated:YES];
}



@end
