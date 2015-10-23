//
//  ANWSetCalculatorViewController.h
//  Post Tonal Theory Calculator
//
//  Created by Adam Waller on 7/16/15.
//  Copyright (c) 2015 Adam Waller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANWSetCalculatorViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *pitchClassViews;
@property (nonatomic, strong) NSMutableArray *tempButtons;

- (void)transposeOrInvertButtonPressed:(UIButton *)button;
- (void)TIButtonPressed:(UIButton *)button;
- (void)complementButtonPressed:(UIButton *)button;
- (void)handleOutsideTap:(UIGestureRecognizer *)recognizer;

//- (void)changeBackgroundColor;

@end
