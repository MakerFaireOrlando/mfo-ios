//
//  MakerDetailViewController.m
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 7/28/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "MakerDetailViewController.h"

@interface MakerDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *makerProjectName;
@property (weak, nonatomic) IBOutlet UILabel *makerLocation;
@property (weak, nonatomic) IBOutlet UITextView *makerDescription;


@end

@implementation MakerDetailViewController

-(void)setupView
{
    //self.navigationItem.title = [_maker projectName];
    [_makerProjectName setText:[_maker projectName]];
    [_makerLocation setText:[_maker location]];
    [_makerDescription setText:[_maker descript]];
    CGRect frame = _makerDescription.frame;
    frame.size.height = _makerDescription.contentSize.height;
    _makerDescription.frame = frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
