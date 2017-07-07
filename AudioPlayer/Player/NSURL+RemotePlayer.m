//
//  NSURL+RemotePlayer.m
//  AudioPlayer
//
//  Created by 王志盼 on 2017/7/7.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import "NSURL+RemotePlayer.h"

@implementation NSURL (RemotePlayer)
- (NSURL *)steamingUrl
{
    NSURLComponents *compents = [NSURLComponents componentsWithString:self.absoluteString];
    compents.scheme = @"sreaming";
    return compents.URL;
}
@end
