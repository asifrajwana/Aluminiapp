//
//  AlumniSearchCustomCellTableViewCell.m
//  Uni Alnmni
//
//  Created by asif on 16/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "AlumniSearchCustomCellTableViewCell.h"
#import "Constants.h"
@implementation AlumniSearchCustomCellTableViewCell

@synthesize cellImage,cellCatagoryText,cellSelectedText;

- (void)awakeFromNib {
    cellCatagoryText.textColor=BLUE_LIGHT_Color;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
