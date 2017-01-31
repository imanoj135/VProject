//
//  UIViewController+Alert.h
//  MusicPlayer
//
//  Created by Manoj kumar on 1/30/17.
//  Copyright © 2017 Manoj kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)
- (void)showAlertWithMessage:(NSString*) message
                       title:(NSString*) title
                    delegate:(id)delegate
          cancelButtonAction:(UIAlertAction*) cancelAction
           otherButtonAction:(UIAlertAction*) otherAction;
-(void)showLoading;
-(void)hideLoading;
@end
