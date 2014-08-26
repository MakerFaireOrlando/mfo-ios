//
//  CategoryTableViewCell.h
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 8/23/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *label;

- (void)reselect;

- (void)deselect;
@end
