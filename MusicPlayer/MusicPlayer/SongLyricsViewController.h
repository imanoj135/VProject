//
//  SongLyricsViewController.h
//  MusicPlayer
//
//  Created by Manoj kumar on 1/30/17.
//  Copyright © 2017 Manoj kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceAgent.h"

@interface SongLyricsViewController : UIViewController<ServiceAgentDelegate>
@property (nonatomic,weak) NSDictionary *songDict;
@end
