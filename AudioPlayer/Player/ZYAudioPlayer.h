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

- (void)playWithURL:(NSURL *)url isCache:(BOOL)isCache;

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



@property (nonatomic, assign) BOOL muted;
@property (nonatomic, assign) float volume;
@property (nonatomic, assign) float rate;


@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
@property (nonatomic, copy, readonly) NSString *totalTimeFormat;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, copy, readonly) NSString *currentTimeFormat;


@property (nonatomic, assign, readonly) float progress;
@property (nonatomic, strong, readonly) NSURL *url;
//缓冲进度
@property (nonatomic, assign, readonly) float loadDataProgress;
@end
