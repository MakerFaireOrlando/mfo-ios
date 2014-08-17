//
//  UIColor+MakerColors.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 8/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "UIColor+MakerColors.h"

@implementation UIColor (MakerColors)

+ (UIColor *)makerBlue
{
    return [UIColor colorWithHue:196.0/360.0
                      saturation:100.0/100.0
                      brightness:94.0/100.0
                           alpha:1.0];
}

+ (UIColor *)makerRed
{
    return  [UIColor colorWithHue:359/360.0
                       saturation:74/100.0
                       brightness:94/100.0
                            alpha:1.0];
}

@end
