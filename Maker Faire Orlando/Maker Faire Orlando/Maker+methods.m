//
//  Maker+methods.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/16/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "Maker+methods.h"

#define kMakersURL @"http://callformakers.org/orlando2014/default/overviewALL.json/raw"

@implementation Maker (methods)

+ (void)updateMakers
{
    NSURL *makersURL = [NSURL URLWithString:kMakersURL];
    
}

@end
