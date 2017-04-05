//
//  MediaViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/17.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "MediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseBundle.h"

@interface MediaViewController ()

@property (readwrite, nonatomic, strong) MPMoviePlayerViewController *moviePlayer;
@property (readwrite, nonatomic, strong) NSURL * url;
@property (readwrite, nonatomic, strong) AVPlayer * player;
@property (readwrite, nonatomic, strong) AVPlayerItem * playerItem;

@end

@implementation MediaViewController


- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_media_play" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVideoPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initVideoPlayer {
    if(!_moviePlayer) {
        _moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:_url];
        _moviePlayer.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
        _moviePlayer.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        _moviePlayer.moviePlayer.allowsAirPlay = YES;
        
        [self.view addSubview:_moviePlayer.view];
        [_moviePlayer.view setFrame:[self getContentFrame]];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:[_moviePlayer moviePlayer]]; //播放完后的通知
        
    } else {
        _moviePlayer.moviePlayer.contentURL = _url;
    }
    [_moviePlayer.moviePlayer play];
//
//    [self playAudioWith:_url];
}

- (void) playAudioWith:(NSURL*) url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){

            if(_playerItem) {
                [_playerItem removeObserver:self forKeyPath:@"status"];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
                _playerItem = nil;
            }
        
            
            _playerItem = [AVPlayerItem playerItemWithURL:_url];
            [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
//
            _player = [AVPlayer playerWithPlayerItem:_playerItem];
        
//        _player = [AVPlayer playerWithURL:_url];
        
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
//
            [_player play];
        
    });
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if ([_playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            //            self.stateButton.enabled = YES;
            CMTime duration = self.playerItem.duration;// 获取视频总长度
            //            CGFloat totalSecond = _playerItem.duration.value / _playerItem.duration.timescale;// 转换成秒
            //            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
        } else if ([_playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
            NSLog(@"Error:%@", _playerItem.error.description);
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
    }
}

- (void) mediaDidEnd:(id) obj {
    NSLog(@"音频播放完成");
//    [_playerItem removeObserver:self forKeyPath:@"status"];
//    _playerItem = nil;
}

-(void)movieFinishedCallback:(NSNotification*)notify {
    //    [self dismissMoviePlayerViewControllerAnimated];
    [self finish];
}

- (void) setUrl:(NSURL *)url {
    _url = [url copy];
    _moviePlayer.moviePlayer.contentURL = _url;
//    [_moviePlayer.moviePlayer prepareToPlay];
}
@end
