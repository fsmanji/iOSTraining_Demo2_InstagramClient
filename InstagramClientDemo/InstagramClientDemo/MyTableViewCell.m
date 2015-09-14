//
//  MyTableViewCell.m
//  InstagramClientDemo
//
//  Created by Cristan Zhang on 9/14/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "MyTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MyTableViewCell

@synthesize myPhotoView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setPhotoUrl: (NSURL *)url {
    [myPhotoView setImageWithURL:url];
}

@end
