//
//  MusicPlayerCell.m
//  MusicPlayer
//
//  Created by Manoj kumar on 1/30/17.
//  Copyright © 2017 Manoj kumar. All rights reserved.
//

#import "MusicPlayerCell.h"

@implementation MusicPlayerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tablecellImageView.layer.cornerRadius = 5.0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
