//
//  ZYAudioPlayer.h
//  AudioPlayer
//
//  Created by 王志盼 on 2017/6/30.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZYAudioPlayerState) {
    ZYAudioPlayerStateUnknown,  //未知(例如没有开始播放音乐)
    ZYAudioPlayerStateLoading,  //正在加载资源
    ZYAudioPlayerStatePlaying,  //正在播放
    ZYAudioPlayerStatePause,    //暂停播放
    ZYAudioPlayerStateStoped,   //停止播放
    ZYAudioPlayerStateFailed    //失败
};

@interface ZYAudioPlayer : NSObject <NSCopying>
+ (instancetype)sharedInstance;

/**
 根据一个url地址, 播放相关的远程音频资源
 */
- (void)playWithURL:(NSURL *)url;

- (void)pause;

/**
 回复播放
 */
- (void)resume;

/**
 停止
 */
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


/** 是否静音 */
@property (nonatomic, assign) BOOL muted;
/** 音量大小 */
@property (nonatomic, assign) float volume;
/** 播放速率 */
@property (nonatomic, assign) float rate;

/** 总时长 */
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
@property (nonatomic, copy, readonly) NSString *totalTimeFormat;

/** 已经播放时长 */
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, copy, readonly) NSString *currentTimeFormat;


/** 播放进度 */
@property (nonatomic, assign, readonly) float progress;

/** 当前播放url */
@property (nonatomic, strong, readonly) NSURL *url;
//缓冲进度
@property (nonatomic, assign, readonly) float loadDataProgress;

//播放状态
@property (nonatomic, assign, readonly) ZYAudioPlayerState state;
@end
