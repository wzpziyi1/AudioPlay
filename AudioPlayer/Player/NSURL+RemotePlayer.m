//
//  NSURL+RemotePlayer.m
//  AudioPlayer
//
//  Created by 王志盼 on 2017/7/7.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import "NSURL+RemotePlayer.h"

@implementation NSURL (RemotePlayer)
- (NSURL *)streamingUrl
{
    NSURLComponents *compents = [NSURLComponents componentsWithString:self.absoluteString];
    compents.scheme = @"sreaming";
    return compents.URL;
}

- (NSURL *)httpURL {
    NSURLComponents *compents = [NSURLComponents componentsWithString:self.absoluteString];
    compents.scheme = @"http";
    return compents.URL;
    
    
}
@end
