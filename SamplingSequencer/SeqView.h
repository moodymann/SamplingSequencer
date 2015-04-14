//
//  SeqView.h
//  SimpleSeq
//
//  Created by isid on 2014/08/08.
//  Copyright (c) 2014年 SimpleSeq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeqView : UIView

@property(nonatomic, retain)NSMutableArray* stepsDown;
@property(nonatomic, assign)NSInteger currentStep;

- (void)timerFired:(NSInteger)step;

@end