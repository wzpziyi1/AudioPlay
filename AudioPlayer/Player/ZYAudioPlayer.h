//
//  ZYAudioPlayer.h
//  AudioPlayer
//
//  Created by 王志盼 on 2017/6/30.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYAudioPlayer : NSObject
+ (instancetype)sharedInstance;

- (void)playWithUrl:(NSURL *)url;

- (void)pause;
- (void)resume;
- (void)stop;


/**
 快进or快退多少秒
 退为负数
 */
- (void)forwardOrBackWithTimeSec:(NSTimeInterval)timeSec;


/**
 从某个进度（时间点）开始播放
 */
- (void)playOnProgress:(float)progress;

- (void)setRate:(float)rate;

- (void)setMuted:(BOOL)muted;

- (void)setVolume:(float)volume;
@end
