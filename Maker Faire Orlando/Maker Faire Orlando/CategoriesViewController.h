//
//  CategoriesViewController.h
//  Maker Faire Orlando
//
//  Created by Jeffrey Klarfeld on 8/22/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryDelegate <NSObject>

@required

- (void)selectionUpdatedWithCats:(NSArray *)categories;

- (void)clearCategories;

@end

@interface CategoriesViewController : UIViewController

@property (strong, nonatomic) NSArray *selectedCategories;

@property (weak, nonatomic) id<CategoryDelegate> delegate;

@end
