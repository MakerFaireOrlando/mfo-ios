//
//  Maker+methods.h
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/16/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "Maker.h"

@interface Maker (methods)

#define kMakersArrived @"com.makerfaireorlando.mfo.makersarrived"
#define kMakersFailed @"com.makerfaireorlando.mfo.makersfailedtoarrive"

+ (void)updateMakers;

@end
