//
//  ZYAudioPlayer.m
//  AudioPlayer
//
//  Created by 王志盼 on 2017/6/30.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import "ZYAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "ZYRemoteResourceLoaderDelegate.h"
#import "NSURL+RemotePlayer.h"

@interface ZYAudioPlayer()
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) ZYRemoteResourceLoaderDelegate *resourceLoaderDelegate;
@property (nonatomic, strong, readwrite) NSURL *url;
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

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:zone];
        });
    }
    return _instance;
}

- (void)playWithURL:(NSURL *)url isCache:(BOOL)isCache
{
    [self removeAllObserver];
    
    self.url = url;
    if (isCache)
    {
        //把http://
        //变成stream://   这样可以让resourceLoaderDelegate拦截加载，从而自己操作数据
        url = [url steamingUrl];
    }
    
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    // 关于网络音频的请求, 是通过这个对象, 调用代理的相关方法, 进行加载的
    // 拦截加载的请求, 只需要, 重新修改它的代理方法就可以
    self.resourceLoaderDelegate = [[ZYRemoteResourceLoaderDelegate alloc] init];
    [asset.resourceLoader setDelegate:self.resourceLoaderDelegate queue:dispatch_get_main_queue()];
    //资源组织者
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    
    //监听状态，资源准备好了之后, 再进行播放
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

- (NSString *)currentTimeFormat {
    return [NSString stringWithFormat:@"%02zd:%02zd", (int)self.currentTime / 60, (int)self.currentTime % 60];
}

- (NSString *)totalTimeFormat {
    return [NSString stringWithFormat:@"%02zd:%02zd", (int)self.totalTime / 60, (int)self.totalTime % 60];
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

- (float)volume
{
    return self.player.volume;
}

- (BOOL)muted
{
    return self.player.muted;
}

- (float)rate
{
    return self.player.rate;
}

-(NSTimeInterval)totalTime {
    CMTime totalTime = self.player.currentItem.duration;
    NSTimeInterval totalTimeSec = CMTimeGetSeconds(totalTime);
    if (isnan(totalTimeSec)) {
        return 0;
    }
    return totalTimeSec;
}

- (NSTimeInterval)currentTime {
    CMTime playTime = self.player.currentItem.currentTime;
    NSTimeInterval playTimeSec = CMTimeGetSeconds(playTime);
    if (isnan(playTimeSec)) {
        return 0;
    }
    return playTimeSec;
}

- (float)progress {
    if (self.totalTime == 0) {
        return 0;
    }
    return self.currentTime / self.totalTime;
}


- (float)loadDataProgress {
    
    if (self.totalTime == 0) {
        return 0;
    }
    
    CMTimeRange timeRange = [[self.player.currentItem loadedTimeRanges].lastObject CMTimeRangeValue];
    
    CMTime loadTime = CMTimeAdd(timeRange.start, timeRange.duration);
    NSTimeInterval loadTimeSec = CMTimeGetSeconds(loadTime);
    
    return loadTimeSec / self.totalTime;
    
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
