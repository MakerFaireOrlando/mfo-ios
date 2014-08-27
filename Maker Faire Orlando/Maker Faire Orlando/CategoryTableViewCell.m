//
//  CategoryTableViewCell.m
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 8/23/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor makerBlue]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
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
    
    if (selected && (self.accessoryType == UITableViewCellAccessoryNone))
    {
       [self setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
         [self setAccessoryType:UITableViewCellAccessoryNone];
    }

    // Configure the view for the selected state
}

- (void)reselect
{
    [self setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void)deselect
{
    [self setAccessoryType:UITableViewCellAccessoryNone];
}

@end
