//
//  MakerDetailViewController.m
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 7/28/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "MakerDetailViewController.h"
#import "Photo.h"
#import "Maker+methods.h"

@interface MakerDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *photoCell;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UILabel *organizationLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;

@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;

- (IBAction)launchWebsite:(UIButton *)sender;
- (IBAction)launchVideoSite:(UIButton *)sender;
@end

@implementation MakerDetailViewController

@synthesize maker = _maker;

-(void)setupView
{
    NSArray *defaultAnimation = @[[UIImage imageNamed:@"DefaultMakerStart"],
                                  [UIImage imageNamed:@"DefaultMakerImage"]];
    
    [_photoView setImage:[UIImage animatedImageWithImages:defaultAnimation
                                                 duration:1.5f]];
    
    if (_maker.photos.count > 0)
    {
        Photo *makerPhoto = [_maker.photos anyObject];
        if (makerPhoto.image != nil && makerPhoto.image.length > 0)
        {
            [_photoView setImage:[UIImage imageWithData:makerPhoto.image]];
        }
        else
        {
            [self asyncPhoto:makerPhoto];
        }
    }
    
    [_projectLabel          setText:_maker.projectName];
    [_organizationLabel     setText:_maker.organization];
    [_descriptionTextView   setText:_maker.descript];
    [_categoriesLabel       setText:_maker.categories];
    [_locationLabel         setText:_maker.location];
    
    if (_maker.websiteURL == nil || [_maker.websiteURL isEqualToString:@""])
    {
        [_websiteButton setEnabled:NO];
    }
    
    if (_maker.videoURL == nil || [_maker.videoURL isEqualToString:@""])
    {
        [_videoButton setEnabled:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            return 200.0f;
        case 1:
        {
            if (indexPath.row == 0)
            {
                if (_maker.organization == nil || [_maker.organization isEqualToString:@""])
                {
                    return 48.0f;
                }
                return 87.0f;
            }
            return 33.0f;
        }
        case 2:
        {
            if (indexPath.row == 0)
            {
                CGSize sizeThatShouldFitTheContent = [_descriptionTextView sizeThatFits:_descriptionTextView.frame.size];
                return sizeThatShouldFitTheContent.height;
            }
            return 33.0f;
        }
        case 3:
        {
            return 44.0f;
        }
        default:
            return 44.0f;
    }
    
}

- (void)asyncPhoto:(Photo *)photo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.sourceURL]];
        
        if (image)
        {
            [photo setImage:image];
            
            UIImage *finalImage = [UIImage imageWithData:photo.image];
            
            [_photoView setAlpha:0.0f];
            
            [_photoView setImage:finalImage];
            
            __weak MakerDetailViewController *weakSelf = self;
            
            [UIView animateWithDuration:1.5f
                                  delay:0.0f
                 usingSpringWithDamping:0.5f
                  initialSpringVelocity:0.5f
                                options:0
                             animations:^
            {
                [weakSelf.photoView setAlpha:1.0f];
            }
                             completion:nil];
        }
    });
}

- (IBAction)launchWebsite:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_maker.websiteURL]];
}

- (IBAction)launchVideoSite:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_maker.videoURL]];
}
@end
