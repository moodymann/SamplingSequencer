//
//  FirstViewController.m
//  SamplingSequencer
//
//  Created by isid on 2014/09/01.
//  Copyright (c) 2014年 neckpain. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
{
    __weak IBOutlet HeaderView *headerView;
    __weak IBOutlet SeqView *seqView;
}

@end

@implementation FirstViewController

@synthesize sequencer = _sequencer;
@synthesize sampler = _sampler;

- (void)viewDidLoad
{
    [super viewDidLoad];

    _sequencer = [[Sequencer alloc]init];
    _sequencer.delegate = self;
    headerView.delegate = self;
    
    self.isRecording = NO;
    
    /*
     Customizing the audio plot's look
     */
    // Background color
    self.audioPlot.backgroundColor = [UIColor colorWithRed: 0.984 green: 0.71 blue: 0.365 alpha: 1];
    // Waveform color
    self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    // Plot type
    self.audioPlot.plotType        = EZPlotTypeRolling;
    // Fill
    self.audioPlot.shouldFill      = YES;
    // Mirror
    self.audioPlot.shouldMirror    = YES;
 
    /*
     Start the microphone
     */
    [self.microphone startFetchingAudio];

}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initializeViewController];
    }
    return self;
}

#pragma mark - Initialize View Controller Here
-(void)initializeViewController {
    // Create an instance of the microphone and tell it to use this view controller instance as the delegate
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    
    NSError *err;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self testFilePathURL]
                                                              error:&err];
    
    [self openFileWithFilePathURL:[NSURL fileURLWithPath:kAudioFileDefault]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat seqMargin_height = 70.0f;
    CGFloat seqHeight = 300.0f;
    
    seqView.frame = CGRectMake(0.0f, seqMargin_height, self.view.bounds.size.width, seqHeight);
}

-(void)openFileWithFilePathURL:(NSURL*)filePathURL {
    
    // Stop playback
    [[EZOutput sharedOutput] stopPlayback];
    
    self.audioFile                        = [EZAudioFile audioFileWithURL:filePathURL];
    self.audioFile.audioFileDelegate      = self;
    self.eof                              = NO;
//    self.filePathLabel.text               = filePathURL.lastPathComponent;
    self.framePositionSlider.maximumValue = (float)self.audioFile.totalFrames;
    
    // Set the client format from the EZAudioFile on the output
    [[EZOutput sharedOutput] setAudioStreamBasicDescription:self.audioFile.clientFormat];
    
    // Plot the whole waveform
    self.audioPlot.plotType        = EZPlotTypeBuffer;
    self.audioPlot.shouldFill      = YES;
    self.audioPlot.shouldMirror    = YES;
    [self.audioFile getWaveformDataWithCompletionBlock:^(float *waveformData, UInt32 length) {
        [self.audioPlot updateBuffer:waveformData withBufferSize:length];
    }];
    
}

#pragma mark headerview delegate method
- (void)playButtonEvent
{
    [_sequencer play];
}

- (void)stopButtonEvent
{
    if( self.audioPlayer )
    {
        if( self.audioPlayer.playing )
        {
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
    }

    seqView.currentStep = -1;
    [seqView setNeedsDisplay];
    
    [_sequencer stop];
}

#pragma mark seqview delegate method
- (void)sequencer:(Sequencer*)sequencer didTriggerStep:(NSUInteger)step
{
//    NSInteger noteNumber;
    if ([[seqView.stepsDown objectAtIndex:step] isEqualToString:@"1"]) {
//        noteNumber = 36; // kick
//        [_sampler triggerNote:noteNumber];
        if( self.audioPlayer )
        {
            if( self.audioPlayer.playing )
            {
                [self.audioPlayer stop];
            }
            self.audioPlayer = nil;
        }
        NSError *err;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self testFilePathURL]
                                                                  error:&err];
        self.audioPlayer.rate = 2.0;
        [self.audioPlayer play];
        self.audioPlayer.delegate = self;

    }else{
        
    }
    [seqView timerFired:step];
}

#pragma mark - EZMicrophoneDelegate
// Note that any callback that provides streamed audio data (like streaming microphone input) happens on a separate audio thread that should not be blocked. When we feed audio data into any of the UI components we need to explicity create a GCD block on the main thread to properly get the UI to work.
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.
    
    // See the Thread Safety warning above, but in a nutshell these callbacks happen on a separate audio thread. We wrap any UI updating in a GCD block on the main thread to avoid blocking that audio flow.
    dispatch_async(dispatch_get_main_queue(),^{
        // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
        if (self.isRecording) {
            [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
        }
    });
}

-(void)microphone:(EZMicrophone *)microphone
    hasBufferList:(AudioBufferList *)bufferList
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    
    // Getting audio data as a buffer list that can be directly fed into the EZRecorder. This is happening on the audio thread - any UI updating needs a GCD main queue block. This will keep appending data to the tail of the audio file.
    if( self.isRecording ){
        [self.recorder appendDataFromBufferList:bufferList
                                 withBufferSize:bufferSize];
    }
    
}


#pragma mark - Utility
-(NSArray*)applicationDocuments {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
}

-(NSString*)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(NSURL*)testFilePathURL {
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
                                   [self applicationDocumentsDirectory],
                                   kAudioFilePath]];
}

#pragma mark - UI Event
- (IBAction)recStart:(id)sender {
    if (!self.isRecording) {
        self.isRecording = YES;
        [self.audioPlot clear];
        self.audioPlot.plotType        = EZPlotTypeRolling;
        [self.recButton setTitle:@"Stop" forState:UIControlStateNormal];
        
        self.recorder = [EZRecorder recorderWithDestinationURL:[self testFilePathURL]
                                                  sourceFormat:self.microphone.audioStreamBasicDescription
                                           destinationFileType:EZRecorderFileTypeAIFF];
        
    }else{
        self.isRecording = NO;
        [self.recButton setTitle:@"Rec" forState:UIControlStateNormal];
        [self.recorder closeAudioFile];

        NSError *err; 
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self testFilePathURL]
                                                                  error:&err];
//        
//        self.audioFile = nil;
//        self.audioFile                        = [EZAudioFile audioFileWithURL:[self testFilePathURL]];
//        self.audioFile.audioFileDelegate      = self;
//        self.eof                              = NO;
//        //    self.filePathLabel.text               = filePathURL.lastPathComponent;
//        self.framePositionSlider.maximumValue = (float)self.audioFile.totalFrames;
//        
//        // Plot the whole waveform
//        self.audioPlot.plotType        = EZPlotTypeBuffer;
//        self.audioPlot.shouldFill      = YES;
//        self.audioPlot.shouldMirror    = YES;
//        [self.audioFile getWaveformDataWithCompletionBlock:^(float *waveformData, UInt32 length) {
//            [self.audioPlot updateBuffer:waveformData withBufferSize:length];
//        }];
    }
}

- (IBAction)seekToFrame:(id)sender {
    [self.audioFile seekToFrame:(SInt64)[(UISlider*)sender value]];
}
@end
