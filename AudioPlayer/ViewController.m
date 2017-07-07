//
//  ViewController.m
//  AudioPlayer
//
//  Created by 王志盼 on 2017/6/29.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import "ViewController.h"
#import "ZYAudioPlayer.h"

@interface ViewController ()
@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *loadPV;

@property (weak, nonatomic) IBOutlet UISlider *playSlider;

@property (weak, nonatomic) IBOutlet UIButton *mutedBtn;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@end

@implementation ViewController

- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self timer];
}


- (void)update {
    
    
    // 68
    // 01:08
    // 设计数据模型的
    // 弱业务逻辑存放位置的问题
    self.playTimeLabel.text =  [ZYAudioPlayer sharedInstance].currentTimeFormat;
    self.totalTimeLabel.text = [ZYAudioPlayer sharedInstance].totalTimeFormat;
    
    self.playSlider.value = [ZYAudioPlayer sharedInstance].progress;
    
    self.volumeSlider.value = [ZYAudioPlayer sharedInstance].volume;
    
    NSLog(@"%f", [ZYAudioPlayer sharedInstance].volume);
    
    self.loadPV.progress = [ZYAudioPlayer sharedInstance].loadDataProgress;
    
    self.mutedBtn.selected = [ZYAudioPlayer sharedInstance].muted;
    
    
}


- (IBAction)play:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://audio.xmcdn.com/group23/M04/63/C5/wKgJNFg2qdLCziiYAGQxcTOSBEw402.m4a"];
    [[ZYAudioPlayer sharedInstance] playWithURL:url isCache:NO];
    
}
- (IBAction)pause:(id)sender {
    [[ZYAudioPlayer sharedInstance] pause];
}

- (IBAction)resume:(id)sender {
    [[ZYAudioPlayer sharedInstance] resume];
}
- (IBAction)kuaijin:(id)sender {
    [[ZYAudioPlayer sharedInstance] forwardOrBackWithTimeSec:15];
}
- (IBAction)progress:(UISlider *)sender {
    [[ZYAudioPlayer sharedInstance] playOnProgress:sender.value];
}
- (IBAction)rate:(id)sender {
    [[ZYAudioPlayer sharedInstance] setRate:2];
}
- (IBAction)muted:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[ZYAudioPlayer sharedInstance] setMuted:sender.selected];
}
- (IBAction)volume:(UISlider *)sender {
    [[ZYAudioPlayer sharedInstance] setVolume:sender.value];
}


@end
