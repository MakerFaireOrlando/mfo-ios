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
@property (weak, nonatomic) IBOutlet UILabel *eventStartTime;
@property (weak, nonatomic) IBOutlet UILabel *eventEndTime;

@end


@implementation EventDetailViewController

-(void)setupView
{
    [_eventTitle setText:[_event summary]];
    [_eventLocation setText:[_event location]];
    [_eventDescription setText:[_event descript]];
    
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MM-dd HH:mm" options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    
    NSString *start = [formatter stringFromDate:_event.startTime];
    NSString *end = [formatter stringFromDate:_event.endTime];
    
    [_eventStartTime setText:[NSString stringWithFormat:@"Start:\t%@", start]];
    [_eventEndTime setText:[NSString stringWithFormat:@"End:\t%@", end]];
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
