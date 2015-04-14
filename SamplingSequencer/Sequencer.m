//
//  Sequncer.m
//  SimpleSeq
//
//  Created by isid on 2014/08/13.
//  Copyright (c) 2014年 SimpleSeq. All rights reserved.
//

#import "Sequencer.h"

@implementation Sequencer
{
    NSInteger _currentStep;
}
@synthesize bpm = _bpm;

- (id)init
{
    self = [super init];
    _currentStep = -1;
    _bpm = 120;
    return self;
}

- (void)play
{
    
    _currentStep = 0;
    [_timer invalidate], _timer = nil;
    
    // Calc BPM
    CGFloat sixteenthNoteDuration = (60.0 / _bpm) * 0.25;
    if (sixteenthNoteDuration < 0.075) { //limit BPM 200
        sixteenthNoteDuration = 0.075;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:sixteenthNoteDuration
                                              target:self
                                            selector:@selector(_timerFired:)
                                            userInfo:nil
                                             repeats:YES];
    [self _timerFired:_timer];
}

- (void)stop
{
    [_timer invalidate], _timer = nil;
}

- (void)_timerFired:(NSTimer*)timer
{
    if ([self.delegate respondsToSelector:@selector(sequencer:didTriggerStep:)]) {
        [self.delegate sequencer:self didTriggerStep:_currentStep];
    }
    _currentStep++;
    if (_currentStep == 16) {
        _currentStep = 0;
    }
}

@end
