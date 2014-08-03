//
//  EventDetailViewController.m
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 7/28/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;

@end


@implementation EventDetailViewController

-(void)setupView
{
    [_eventTitle setText:[_event summary]];
    [_eventLocation setText:[_event location]];
    [_eventDescription setText:[_event descript]];
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
