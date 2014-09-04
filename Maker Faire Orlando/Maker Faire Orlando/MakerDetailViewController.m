//
//  MakerDetailViewController.m
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 7/28/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "MakerDetailViewController.h"
#import "Photo.h"

@interface MakerDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *makerProjectName;
@property (weak, nonatomic) IBOutlet UILabel *makerLocation;
@property (weak, nonatomic) IBOutlet UITextView *makerDescription;
@property (weak, nonatomic) IBOutlet UIImageView *makerImage;


@end

@implementation MakerDetailViewController

-(void)setupView
{
    if (_maker.videoURL)
    {
        NSLog(@"videoURL: %@", _maker.videoURL);
    }
    //self.navigationItem.title = [_maker projectName];
    [_makerProjectName setText:[_maker projectName]];
    [_makerLocation setText:[_maker location]];
    [_makerDescription setText:[_maker descript]];
    CGRect frame = _makerDescription.frame;
    frame.size.height = _makerDescription.contentSize.height;
    _makerDescription.frame = frame;
    if (self.maker.photos.count > 0) {
        Photo *photo = [self.maker.photos anyObject];
        if (photo.image == nil) {
            [self loadPictureWithUrl:photo];
        }
        else {
            UIImage* image = [UIImage imageWithData:photo.image];
            [self.makerImage setImage:image];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPictureWithUrl:(Photo*)photo {
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:photo.sourceURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                photo.image = data;
                UIImage* image = [UIImage imageWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.makerImage setImage:image];
                });
            }] resume];
}

@end
