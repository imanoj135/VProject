//
//  MusicPlayerCell.h
//  MusicPlayer
//
//  Created by Manoj kumar on 1/30/17.
//  Copyright © 2017 Manoj kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tablecellImageView;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;

@end
