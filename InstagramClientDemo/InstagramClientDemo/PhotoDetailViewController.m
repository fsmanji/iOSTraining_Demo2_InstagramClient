//
//  PhotoDetailViewController.m
//  InstagramClientDemo
//
//  Created by Cristan Zhang on 9/14/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "PhotoDetailViewController.h"

@interface PhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//Table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myPhoto[@"comments"] count];
}

- (UITableViewCell* )tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    NSInteger row = indexPath.row;
    NSDictionary* commentList = self.myPhoto[@"comments"];
    NSDictionary* comment = commentList[@"data"][row];
    
    cell.textLabel.text = [NSString stringWithFormat:comment[@"text"]];
    return cell;

}


//delegates

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tapped row : %li", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)setPhotoInfo:(NSDictionary *)photo {
    self.myPhoto = photo;
    [self.commentsTableView reloadData];
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
