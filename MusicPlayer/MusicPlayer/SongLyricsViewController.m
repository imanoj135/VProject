//
//  SongLyricsViewController.m
//  MusicPlayer
//
//  Created by Manoj kumar on 1/30/17.
//  Copyright © 2017 Manoj kumar. All rights reserved.
//

#import "SongLyricsViewController.h"
#import "UIViewController+Alert.h"
#import "Constants.h"
@interface SongLyricsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *songImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UITextView *songLyrics;

@end

@implementation SongLyricsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self populateUI];
    [self loadLyrics];
    // Do any additional setup after loading the view.
}
-(void)populateUI{
    self.navigationItem.title = @"Lyrics";
    self.songName.text = [self.songDict objectForKey:@"trackName"];
    self.categoryName.text = [self.songDict objectForKey:@"artistName"];
    [self loadImage];
}

-(void)loadImage{
    NSURL *url = [NSURL URLWithString:[self.songDict objectForKey:@"artworkUrl100"]];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{

                    _songImage.image= image;
                });
            }
        }
    }];
    [task resume];
}

-(void)loadLyrics{
    WebServiceAgent *agent = [[WebServiceAgent alloc]init];
    agent.delegate = self;
    [agent getJSONResponse:[NSString stringWithFormat:@"http://lyrics.wikia.com/api.php?func=getSong&artist=%@&song=%@&fmt=json",[[self.songDict objectForKey:@"artistName"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],[[self.songDict objectForKey:@"trackName"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    //    [self showLoading];
}

//Service Agent Delegate

- (void)setResponseData:(NSData *)data{
//    NSLog(@"setResponseData : %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [self parseJsonData:data];
}
- (void)handleError:(NSError *)error{
    NSLog(@"handleError : %@",[error description]);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [self showAlertWithMessage:[error description] title:kAPPNAME delegate:nil cancelButtonAction:cancelAction otherButtonAction:nil];
}

-(void)parseJsonData:(NSData *)data{
    NSString* rawString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *processedString = [rawString stringByReplacingOccurrencesOfString:@"song = " withString:@""];
    processedString = [processedString stringByReplacingOccurrencesOfString:@"{" withString:@""];
    processedString = [processedString stringByReplacingOccurrencesOfString:@"}" withString:@""];
    processedString = [processedString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    processedString = [processedString stringByReplacingOccurrencesOfString:@"," withString:@"\n"];

//    NSData *processedData = [processedString dataUsingEncoding:NSUTF8StringEncoding];
    //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:processedData options:0 error:nil];
    //    [self hideLoading];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //NSDictionary *dict = [json objectForKey:@"song"];
        _songLyrics.text = processedString;

    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
