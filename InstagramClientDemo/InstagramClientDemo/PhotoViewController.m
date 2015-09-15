//
//  PhotoViewController.m
//  InstagramClientDemo
//
//  Created by Cristan Zhang on 9/14/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "PhotoViewController.h"
#import "Constants.h"
#import <AFNetworking/AFNetworking.h>
#import "MyTableViewCell.h"
#import "PhotoDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PhotoViewController ()
//views
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//data
@property NSDictionary *responseDictionary;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self sendRequest];
    
    [self.tableView setRowHeight:320];
    
    //add a PTR control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onPullToRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    //self.tableView.tableHeaderView = self.refreshControl;
    
    
    //add a progress indicator
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = tableFooterView.center;
    [tableFooterView addSubview:loadingView];
    self.tableView.tableFooterView = tableFooterView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) sendRequest{
    NSURL *url = [NSURL URLWithString:kInstagramURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self.refreshControl endRefreshing];
        [self onDataLoaded];
        NSLog(@"response: %@", self.responseDictionary);
    }];
}


//Table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.responseDictionary[@"data"] count];
}

- (UITableViewCell* )tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MyTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"com.yahoo.tablecell" forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    [self showPhotoForCell:cell onRow:row onSection:indexPath.section];

    return cell;
}

//delegates

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tapped row : %li", indexPath.row);
    
    //remove the highlight.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [headerView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
    
    UIImageView *profileView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [profileView setClipsToBounds:YES];
    profileView.layer.cornerRadius = 15;
    profileView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.8].CGColor;
    profileView.layer.borderWidth = 1;
    
    // Use the section number to get the right URL
    
    NSDictionary* photo = self.responseDictionary[@"data"][section];
    
    NSDictionary* user = photo[@"user"];
    NSString* profile_url = user[@"profile_picture"];
    NSString* username = user[@"username"];
    
    [profileView setImageWithURL:[NSURL URLWithString:profile_url]];
    
    [headerView addSubview:profileView];
    
    // Add a UILabel for the username here
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
    [headerView addSubview:nameLabel];
    nameLabel.text = username;
    
    // Add a UILabel for the caption here
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 320, 30)];
    [headerView addSubview:titleLabel];
    titleLabel.text = photo[@"caption"][@"text"];
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

-(void)onDataLoaded {
    [self.tableView reloadData];
}

-(void)onPullToRefresh {
    [self sendRequest];
}


//extract the photo url and set it to the UIImageView
- (void) showPhotoForCell:(MyTableViewCell*)cell onRow:(NSInteger)row onSection:(NSInteger)section{
    
    NSDictionary* photo = self.responseDictionary[@"data"][section];
    
    NSDictionary* images = photo[@"images"];
    NSDictionary* lowres = images[@"low_resolution"];
    NSString* url = lowres[@"url"];
    
    [cell setPhotoUrl:[NSURL URLWithString:url]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    PhotoDetailViewController *photoDetailViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSInteger section = indexPath.section;
    [photoDetailViewController setPhotoInfo:self.responseDictionary[@"data"][section]];
}


@end
