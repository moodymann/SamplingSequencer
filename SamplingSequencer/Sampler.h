//
//  Sampler.h
//  SimpleSeq
//
//  Created by isid on 2014/08/14.
//  Copyright (c) 2014年 SimpleSeq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Sampler : NSObject
{
    AUGraph     _AUGraph;
    AudioUnit   _samplerUnit;
}

-(OSStatus)loadFromDLSOrSoundFont:(NSURL *)bankURL withPatch:(int)presetNumber;
- (void)triggerNote:(NSUInteger)note;

@end
