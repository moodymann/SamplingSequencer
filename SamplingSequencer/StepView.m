//
//  StepView.m
//  SimpleSeq
//
//  Created by isid on 2014/08/13.
//  Copyright (c) 2014年 SimpleSeq. All rights reserved.
//

#import "StepView.h"

@implementation StepView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();                       //  コンテキスト取得
    CGContextSaveGState(context);                                               //  グラフィック状態の保存
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextStrokeRect(context, self.bounds);
    CGContextRestoreGState(context);                                            //  グラフィック状態の復元
}

@end
