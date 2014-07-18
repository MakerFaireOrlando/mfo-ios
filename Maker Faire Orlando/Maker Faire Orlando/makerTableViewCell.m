//
//  makerTableViewCell.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 7/17/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "makerTableViewCell.h"

@implementation makerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
