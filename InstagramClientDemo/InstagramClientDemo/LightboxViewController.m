//
//  LightboxViewController.m
//  InstagramClientDemo
//
//  Created by Cristan Zhang on 9/14/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "LightboxViewController.h"
#import "UIImageView+AFNetworking.h"

@interface LightboxViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *fullscreenImageView;


@property NSURL* photoURL;

@end

@implementation LightboxViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView.contentSize = _fullscreenImageView.image.size;
    _scrollView.delegate = self;
    
    if(self.photoURL) {
        [self.fullscreenImageView setImageWithURL:self.photoURL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)onCloseClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setImageUrl:(NSURL *)url {
    
    self.photoURL = url;
    
    if ([self isViewLoaded]) {
        [self.fullscreenImageView setImageWithURL:url];
    }
    
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
