//
//  FirstViewController.h
//  SamplingSequencer
//
//  Created by isid on 2014/09/01.
//  Copyright (c) 2014年 neckpain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "HeaderView.h"
#import "SeqView.h"
#import "Sequencer.h"
#import "Sampler.h"
#import "EZAudio.h"

#define kAudioFilePath @"EZAudioTest.aiff"
#define kAudioFileDefault [[NSBundle mainBundle] pathForResource:@"EZAudioTest" ofType:@"aiff"]

@interface FirstViewController : UIViewController
<AVAudioPlayerDelegate,
EZMicrophoneDelegate,
SequencerDelegate,
HeaderDelegate,
EZAudioFileDelegate,EZOutputDataSource>

@property(nonatomic, strong) EZRecorder *recorder;
@property (nonatomic,strong) EZMicrophone *microphone;
@property(nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) EZAudioFile *audioFile;

@property(nonatomic, strong)Sequencer *sequencer;
@property(nonatomic, strong)Sampler *sampler;

@property (weak, nonatomic) IBOutlet EZAudioPlotGL *audioPlot;

@property (nonatomic,assign) BOOL eof;
@property (nonatomic,assign) BOOL isRecording;

@property (weak, nonatomic) IBOutlet UISlider *framePositionSlider;
@property (weak, nonatomic) IBOutlet UIButton *recButton;

- (IBAction)recStart:(id)sender;

- (IBAction)seekToFrame:(id)sender;
@end
