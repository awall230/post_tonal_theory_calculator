//
//  ANWClockFaceView.h
//  Post Tonal Theory Calculator
//
//  Created by Adam Waller on 7/16/15.
//  Copyright (c) 2015 Adam Waller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANWPCSet.h"

@interface ANWClockFaceView : UIView

@property (nonatomic) CGPoint centerPoint;
@property (nonatomic) float radius;
@property (nonatomic) ANWPCSet *currentPCSet;
@property (nonatomic) NSMutableArray *pitchClassViews;

@property (nonatomic) UILabel *originalSetLabel;
@property (nonatomic) UILabel *normalOrderLabel;
@property (nonatomic) UILabel *primeFormLabel;

- (void)drawLines;

@end
