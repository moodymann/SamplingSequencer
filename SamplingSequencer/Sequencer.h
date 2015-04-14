//
//  Sequncer.h
//  SimpleSeq
//
//  Created by isid on 2014/08/13.
//  Copyright (c) 2014年 SimpleSeq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SequencerDelegate;

@interface Sequencer : NSObject
{
    BOOL    sequence[16];
    NSTimer *_timer;
}

@property(nonatomic, weak)     id<SequencerDelegate> delegate;
@property(nonatomic, assign)CGFloat bpm;

- (void)play;
- (void)stop;

@end

@protocol SequencerDelegate <NSObject>
@optional
- (void)sequencer:(Sequencer*)sequencer didTriggerStep:(NSUInteger)step;
@end
