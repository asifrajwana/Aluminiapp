//
//  AlumniSearchCustomCellTableViewCell.h
//  Uni Alnmni
//
//  Created by asif on 16/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlumniSearchCustomCellTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *cellImage;
@property(nonatomic, weak) IBOutlet UILabel *cellCatagoryText;
@property(nonatomic, weak) IBOutlet UILabel *cellSelectedText;

@end
