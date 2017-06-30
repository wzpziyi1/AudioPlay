//
//  ZYAudioPlayer.m
//  AudioPlayer
//
//  Created by 王志盼 on 2017/6/30.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import "ZYAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ZYAudioPlayer()
@property (nonatomic, strong) AVPlayer *player;

@end

static id _instance = nil;
@implementation ZYAudioPlayer
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

- (void)playWithUrl:(NSURL *)url
{
    AVAsset *asset = [AVAsset assetWithURL:url];
    //资源组织者
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    
    //监听状态
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.player = [AVPlayer playerWithPlayerItem:item];
}

#pragma mark - 播放处理
- (void)pause
{
    [self.player pause];
}
- (void)resume
{
    [self.player play];
}
- (void)stop
{
    [self.player pause];
    self.player = nil;
}


/**
 快进or快退多少秒
 退为负数
 */
- (void)forwardOrBackWithTimeSec:(NSTimeInterval)timeSec
{
    NSTimeInterval totalSec = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentSec = CMTimeGetSeconds(self.player.currentTime);
    currentSec += timeSec;
    
    float progress = currentSec / totalSec;
    [self playOnProgress:progress];
}


/**
 从某个进度（时间点）开始播放
 */
- (void)playOnProgress:(float)progress
{
    
    if (progress < 0 || progress > 1) {
        return;
    }
    
    NSTimeInterval totalSec = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval playSec = totalSec * progress;
    CMTime playTime = CMTimeMake(playSec, 1);
    [self.player seekToTime:playTime completionHandler:^(BOOL finished) {
        if (finished)
        {
            NSLog(@"跳转播放成功");
        }
        else
        {
            NSLog(@"跳转播放失败");
        }
    }];
}

- (void)setRate:(float)rate
{
    [self.player setRate:rate];
}

- (void)setMuted:(BOOL)muted
{
    [self.player setMuted:muted];
}

- (void)setVolume:(float)volume
{
    if (volume < 0 || volume > 1) {
        return;
    }
    if (volume > 0) {
        [self setMuted:NO];
    }
    
    [self.player setVolume:volume];
}

#pragma mark - kvo处理

- (void)removeAllObserver
{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        
        //资源准备完毕
        if (status == AVPlayerItemStatusReadyToPlay)
        {
            NSLog(@"资源准备完毕，开始播放");
            [self resume];
        }
        else   //状态未知
        {
            NSLog(@"资源未知错误");
        }
        
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
