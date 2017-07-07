//
//  NSURL+RemotePlayer.h
//  AudioPlayer
//
//  Created by 王志盼 on 2017/7/7.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (RemotePlayer)
// 获取streaming协议的url地址
- (NSURL *)streamingUrl;

- (NSURL *)httpURL;
@end
