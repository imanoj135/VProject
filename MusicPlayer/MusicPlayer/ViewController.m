//
//  ViewController.m
//  MusicPlayer
//
//  Created by Manoj kumar on 1/30/17.
//  Copyright © 2017 Manoj kumar. All rights reserved.
//

#import "ViewController.h"
#import "MusicPlayerCell.h"
#import "UIViewController+Alert.h"
#import "Constants.h"
#import "SongLyricsViewController.h"
@interface ViewController ()
@property (nonatomic,retain) NSMutableArray *tableViewContentArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewContentArray = [NSMutableArray array];
    [self getDataForSearchTerm:@"tom+waits"];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *encodedString = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [self getDataForSearchTerm:encodedString];
}


-(void)getDataForSearchTerm:(NSString *)searchTerm{
    WebServiceAgent *agent = [[WebServiceAgent alloc]init];
    agent.delegate = self;
    [agent getJSONResponse:[NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@",searchTerm ]];
    //    [self showLoading];
}

-(void)offlineLoad{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SampleResponse" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    [self parseJsonData:data];
    NSLog(@"Async JSON: %@", self.tableViewContentArray);
}

-(void)parseJsonData:(NSData *)data{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //    self.tableViewContentArray = [NSMutableArray arrayWithArray:[json objectForKey:@"data"]];
    self.tableViewContentArray = [NSMutableArray array];
    [self.tableViewContentArray addObjectsFromArray:[json objectForKey:@"results"]];
    //    [self hideLoading];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self sortTableContents];
        [self.musicPlayerTableview reloadData];
    });
}

-(void)sortTableContents{
//    NSLog(@"before sorting : %@",self.tableViewContentArray);
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [self.tableViewContentArray sortedArrayUsingDescriptors:sortDescriptors];
    self.tableViewContentArray = [NSMutableArray arrayWithArray:sortedArray];
    NSLog(@"after sorting : %@",self.tableViewContentArray);
}
//Service Agent Delegate

- (void)setResponseData:(NSData *)data{
    NSLog(@"setResponseData : %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [self parseJsonData:data];
}
- (void)handleError:(NSError *)error{
    NSLog(@"handleError : %@",[error description]);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [self showAlertWithMessage:[error description] title:kAPPNAME delegate:nil cancelButtonAction:cancelAction otherButtonAction:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewContentArray.count;
}

// indexPaths are ordered ascending by geometric distance from the table view
- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    for (NSIndexPath *indexPath in  indexPaths){
        [self fetchDataForIndexPath:indexPath];
    }
}

-(void)fetchDataForIndexPath:(NSIndexPath *)indexpath{
    NSDictionary *content = [self.tableViewContentArray objectAtIndex:indexpath.row];
    NSURL *url = [NSURL URLWithString:[content objectForKey:@"artworkUrl100"]];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{

                    MusicPlayerCell *sampleCell = (MusicPlayerCell *)[self.musicPlayerTableview cellForRowAtIndexPath:indexpath];
                    sampleCell.tablecellImageView.image = image;
                });
            }
        }
    }];
    [task resume];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    MusicPlayerCell *sampleCell = (MusicPlayerCell *)[self.musicPlayerTableview dequeueReusableCellWithIdentifier:@"MusicPlayerCell"];
//    NSDictionary *content = [self.tableViewContentArray objectAtIndex:indexPath.row];
//    sampleCell.songName.lineBreakMode = NSLineBreakByWordWrapping;
//    sampleCell.songName.numberOfLines = 0;
//    NSString *cellText = [content objectForKey:@"trackName"];
//    CGRect textRect = [cellText boundingRectWithSize:CGSizeMake(sampleCell.songName.frame.size.width, CGFLOAT_MAX)
//                                             options:NSStringDrawingUsesLineFragmentOrigin
//                                          attributes:@{NSFontAttributeName: sampleCell.songName.font}
//                                             context:nil];;
//
//    CGSize size = textRect.size;
//    CGRect frame = sampleCell.textLabel.frame;
//    frame.size = size;
//    return size.height + 70;
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicPlayerCell *sampleCell = (MusicPlayerCell *)[self.musicPlayerTableview dequeueReusableCellWithIdentifier:@"MusicPlayerCell"];
    NSDictionary *content = [self.tableViewContentArray objectAtIndex:indexPath.row];
    sampleCell.songName.lineBreakMode = NSLineBreakByWordWrapping;
    sampleCell.songName.numberOfLines = 0;

    NSString *cellText = [content objectForKey:@"trackName"];
    CGRect textRect = [cellText boundingRectWithSize:CGSizeMake(sampleCell.songName.frame.size.width, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: sampleCell.songName.font}
                                             context:nil];;

    CGSize size = textRect.size;
    CGRect frame = sampleCell.textLabel.frame;
    frame.size = size;
    sampleCell.songName.frame = frame;

    sampleCell.songName.text = cellText;
    sampleCell.categoryName.text = [content objectForKey:@"artistName"];
    [self fetchDataForIndexPath:indexPath];
    return sampleCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SongLyricsViewController *songLyrics = (SongLyricsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SongLyricsViewController"];
    songLyrics.songDict = [_tableViewContentArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:songLyrics animated:YES];
}


@end
