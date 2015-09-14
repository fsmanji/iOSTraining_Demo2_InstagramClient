//
//  PhotoDetailViewController.h
//  InstagramClientDemo
//
//  Created by Cristan Zhang on 9/14/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property NSDictionary* myPhoto;

- (void)setPhotoInfo:(NSDictionary*)photo;

@end
