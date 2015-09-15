//
//  PhotoDetailViewController.m
//  InstagramClientDemo
//
//  Created by Cristan Zhang on 9/14/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "LightboxViewController.h"


@interface PhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *highResImageView;

- (IBAction)onTapOnPhoto:(id)sender;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
    self.highResImageView.userInteractionEnabled = YES;
    if(_myPhoto) {
        [self updateViews];
    }
    
    //the following is how to programmically add gesture support.
    
    /*
     UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(onTapOnPhoto:)];
    [tapRecognizer setNumberOfTouchesRequired:2];
    [tapRecognizer setDelegate:self];
    //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
    self.highResImageView.userInteractionEnabled = YES;
    [self.highResImageView addGestureRecognizer:tapRecognizer];
     */
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
    
    if([self isViewLoaded]) {
        [self updateViews];
    }
}

-(void)updateViews {
    dispatch_async(dispatch_get_main_queue(), ^{
        //load comments list
        [self.commentsTableView reloadData];
        //load the photo
        NSDictionary* images = self.myPhoto[@"images"];
        NSDictionary* highres = images[@"standard_resolution"];
        NSString* urlstring = highres[@"url"];
        NSURL* url = [NSURL URLWithString:urlstring];
        [self.highResImageView setImageWithURL:url];
        
    });
}


- (IBAction)onTapOnPhoto:(id)sender{
    NSLog(@"---- tapped on photo --- ");
    LightboxViewController *lightboxController = [self.storyboard instantiateViewControllerWithIdentifier:@"LightboxViewController"];
    [self presentViewController:lightboxController animated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    LightboxViewController* lightbox = [segue destinationViewController];
    NSDictionary* images = self.myPhoto[@"images"];
    NSDictionary* highres = images[@"standard_resolution"];
    NSString* urlstring = highres[@"url"];
    NSURL* url = [NSURL URLWithString:urlstring];
    
    [lightbox setImageUrl:url];
}


@end
