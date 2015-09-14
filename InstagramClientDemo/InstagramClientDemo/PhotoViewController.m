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

@interface PhotoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSDictionary *responseDictionary;

@end

@implementation PhotoViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self connectToServer];
    
    [tableView setRowHeight:320];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) connectToServer{
    NSURL *url = [NSURL URLWithString:kInstagramURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self onDataLoaded];
        NSLog(@"response: %@", self.responseDictionary);
    }];
}


//Table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell* )tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    //cell.textLabel.text = [NSString stringWithFormat:@"Row: %li", (long)indexPath.row];
    //return cell;
    MyTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"com.yahoo.tablecell" forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    [self showPhotoForCell:cell onRow:row];

    return cell;
}

//delegates

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tapped row : %li", indexPath.row);
    
    //remove the highlight.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)onDataLoaded {
    [self.tableView reloadData];
}


//extract the photo url and set it to the UIImageView
- (void) showPhotoForCell:(MyTableViewCell*)cell onRow:(NSInteger)row {
    
    NSDictionary* photo = self.responseDictionary[@"data"][row];
    
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
    NSIndexPath *indexPath = [tableView indexPathForCell:sender];
    NSInteger row = indexPath.row;
    [photoDetailViewController setPhotoInfo:self.responseDictionary[@"data"][row]];
}


@end