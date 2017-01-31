//
//  UIViewController+Alert.m
//  MusicPlayer
//
//  Created by Manoj kumar on 1/30/17.
//  Copyright © 2017 Manoj kumar. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)
- (void)showAlertWithMessage:(NSString*) message
                       title:(NSString*) title
                    delegate:(id)delegate
           cancelButtonAction:(UIAlertAction*) cancelAction
            otherButtonAction:(UIAlertAction*) otherAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if(cancelAction)
         [alert addAction:cancelAction];
    if(otherAction)
        [alert addAction:otherAction];

        dispatch_async(dispatch_get_main_queue(), ^(void){

            [self presentViewController:alert animated:YES completion:nil];
        });
}
-(void)showLoading{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Please wait\n\n\n"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(130.5, 65.5);
    spinner.color = [UIColor blackColor];
    [spinner startAnimating];
    [alert.view addSubview:spinner];

    dispatch_async(dispatch_get_main_queue(), ^(void){
    [self presentViewController:alert animated:NO completion:nil];
        });
}

-(void)hideLoading{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}
@end
