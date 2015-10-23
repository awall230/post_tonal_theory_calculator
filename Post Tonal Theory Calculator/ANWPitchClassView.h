//
//  ANWPitchClassView.h
//  Post Tonal Theory Calculator
//
//  Created by Adam Waller on 7/16/15.
//  Copyright (c) 2015 Adam Waller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANWPitchClassView : UIView

@property (nonatomic) NSInteger pc;
@property (nonatomic) CGPoint centerPoint;
@property (nonatomic) UIColor *color;

- (instancetype)initWithFrame:(CGRect)frame PC:(NSInteger)pc;

@end
