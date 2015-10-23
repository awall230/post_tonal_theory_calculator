//
//  ANWSetCalculatorViewController.m
//  Post Tonal Theory Calculator
//
//  Created by Adam Waller on 7/16/15.
//  Copyright (c) 2015 Adam Waller. All rights reserved.
//

#import "ANWSetCalculatorViewController.h"
#import "ANWClockFaceView.h"
#import "ANWPitchClassView.h"
#import <QuartzCore/QuartzCore.h>

@interface ANWSetCalculatorViewController ()

@property (nonatomic, strong) ANWClockFaceView *clockFace;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *transposeButton;
@property (nonatomic, strong) UIButton *invertButton;
@property (nonatomic, strong) UIButton *complementButton;

@end

@implementation ANWSetCalculatorViewController

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)loadView {
    // Create view
    CGRect frame = [UIScreen mainScreen].bounds;
    self.clockFace = [[ANWClockFaceView alloc] initWithFrame:frame];
    self.containerView = [[UIView alloc] initWithFrame:self.clockFace.frame];
    [self.containerView addSubview:self.clockFace];
    
    // Set as the view of this controller
    self.view = self.containerView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:self.backgroundView atIndex:0];
    [self.view sendSubviewToBack:self.backgroundView];
    self.backgroundView.backgroundColor = [UIColor whiteColor];

    NSTimer *backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:6.0
                                                                target:self
                                                              selector:@selector(changeBackgroundColor)
                                                              userInfo:nil
                                                               repeats:YES];
    
    [backgroundTimer fire];
    
    self.pitchClassViews = [[NSMutableArray alloc] init];
    self.clockFace.pitchClassViews = self.pitchClassViews;
    
    // Create pc circle buttons
    
    CGPoint pcCenter, center;
    ANWPitchClassView *pcButton;
    CGFloat radius, subWidth, subHeight;
    
    center = self.clockFace.centerPoint;
    radius = self.clockFace.radius;
    
    for (int i=0; i<12; i++) {
        pcCenter = CGPointMake(center.x + radius * cos((i-3) * M_PI / 6.0),
                               center.y + radius * sin((i-3) * M_PI / 6.0));
        
        subWidth = subHeight = radius / 4.0;
        
        CGRect subFrame = CGRectMake(pcCenter.x - subWidth/2.0, pcCenter.y - subHeight/2.0,
                                     subWidth, subHeight);
        
        pcButton = [[ANWPitchClassView alloc] initWithFrame:subFrame PC:i];
        pcButton.alpha = 0.0;
        
        [self.pitchClassViews addObject:pcButton];
        [self.clockFace addSubview:pcButton];
        
        [UIView animateWithDuration:0.8
                         animations:^{
                             pcButton.alpha = 1.0;
                         }];
        
    }
    
    // Create T/I buttons
    
    self.transposeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.transposeButton setTitle:@"Transpose"
                        forState:UIControlStateNormal];
    
    self.transposeButton.frame = CGRectMake(width*0.1, height*0.105, width*0.405, height*0.04);
    self.transposeButton.layer.borderWidth = 1.5f;
    [self.transposeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.transposeButton.backgroundColor = [UIColor whiteColor];
    
    // Add action for when button is pressed (current code file is target)
    [self.transposeButton addTarget:self
                           action:@selector(transposeOrInvertButtonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    self.transposeButton.tag = 1;
    
    [self.clockFace addSubview:self.transposeButton];
    
    self.invertButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.invertButton setTitle:@"Invert"
                        forState:UIControlStateNormal];

    self.invertButton.frame = CGRectMake(width*0.5, height*0.105, width*0.4, height*0.04);
    self.invertButton.layer.borderWidth = 1.5f;
    [self.invertButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.invertButton.backgroundColor = [UIColor whiteColor];
    
    // Add action for button press
    [self.invertButton addTarget:self
                     action:@selector(transposeOrInvertButtonPressed:)
           forControlEvents:UIControlEventTouchUpInside];
    
    self.invertButton.tag = 2;
    
    [self.clockFace addSubview:self.invertButton];
    
    self.complementButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.complementButton setTitle:@"Complement"
                  forState:UIControlStateNormal];
    
    self.complementButton.frame = CGRectMake(width*0.1, height*0.143, width*0.8, height*0.04);
    self.complementButton.layer.borderWidth = 1.5f;
    [self.complementButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.complementButton.backgroundColor = [UIColor whiteColor];
    
    // Add action for button press
    [self.complementButton addTarget:self
                     action:@selector(complementButtonPressed:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self.clockFace addSubview:self.complementButton];
    
    UILabel *originalSetLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*0.05,
                                                                          height*0.80,
                                                                          width*0.9,
                                                                          height*0.05)];
    originalSetLabel.text = @"Original Set: ";
    originalSetLabel.numberOfLines = 1;
    originalSetLabel.adjustsFontSizeToFitWidth = YES;
    self.clockFace.originalSetLabel = originalSetLabel;
    [self.clockFace addSubview:originalSetLabel];
    
    UILabel *normalOrderLabel = [[UILabel alloc] initWithFrame:CGRectOffset(originalSetLabel.frame,
                                                                            0.0,
                                                                            height*0.05)];
    normalOrderLabel.text = @"Normal Order: ";
    normalOrderLabel.numberOfLines = 1;
    normalOrderLabel.adjustsFontSizeToFitWidth = YES;
    self.clockFace.normalOrderLabel = normalOrderLabel;
    [self.clockFace addSubview:normalOrderLabel];
    
    UILabel *primeFormLabel = [[UILabel alloc] initWithFrame:CGRectOffset(normalOrderLabel.frame,
                                                                         0.0,
                                                                          height*0.05)];
    primeFormLabel.text = @"Prime Form: ";
    primeFormLabel.numberOfLines = 1;
    primeFormLabel.adjustsFontSizeToFitWidth = YES;
    self.clockFace.primeFormLabel = primeFormLabel;
    [self.clockFace addSubview:primeFormLabel];
    
    UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleOutsideTap:)];
    
    [self.view addGestureRecognizer:singleFingerTap];

    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)transposeOrInvertButtonPressed:(UIButton *)button {
    BOOL isOppositeButton = NO;
    BOOL tempButtonsEmpty = YES;
    
    if ([self.tempButtons count] != 0) {
        tempButtonsEmpty = NO;
        // check if it's the opposite button
        if ((([(UIButton *)self.tempButtons[0] tag] < 200) && (button.tag == 2))
            || (([(UIButton *)self.tempButtons[0] tag] >= 200) && (button.tag == 1))) {
            isOppositeButton = YES;
        }
        for (UIView *subview in self.tempButtons) {
            if (subview.tag >= 100) {
                [subview removeFromSuperview];
            }
        }
        [self.tempButtons removeAllObjects];
        self.complementButton.hidden = NO;
    }
    
    if (isOppositeButton || tempButtonsEmpty) {
        self.complementButton.hidden = YES;
        self.tempButtons = [[NSMutableArray alloc] init];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        for (int i=0; i<12; i++) {
            UIButton *temp = [UIButton buttonWithType:UIButtonTypeSystem];
            [temp setTitle:[NSString stringWithFormat:@"%@%d", (button.tag == 1) ? @"T" : @"I", i]
                  forState:UIControlStateNormal];
            int row = i/6;
            temp.tag = (button.tag == 1) ? 100 + i : 200 + i;
            temp.frame = CGRectMake(width * 0.02 + 0.16*width*(i%6),
                                    height * 0.143 + 0.04*height*row,
                                    width * 0.162,
                                    height * 0.042);
            [temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [temp addTarget:self
                     action:@selector(TIButtonPressed:)
                       forControlEvents:UIControlEventTouchUpInside];
            
            [temp.layer setBorderWidth:1.0f];
            temp.backgroundColor = [UIColor whiteColor];
            
            [self.tempButtons addObject:temp];
            [self.clockFace addSubview:temp];
        }
    }
}

- (void)TIButtonPressed:(UIButton *)button {
    ANWPCSet *currentPCSet = [self.clockFace currentPCSet];
    if (button.tag < 200) { // Transpose button
        [currentPCSet transposeByInterval:(button.tag % 100)];
    }
    else {  // Invert button
        [currentPCSet invertAroundAxis:(button.tag % 100)];
    }
    [self.clockFace setNeedsDisplay];
}

- (void)complementButtonPressed:(UIButton *)button {
    ANWPCSet *currentPCSet = [self.clockFace currentPCSet];
    [currentPCSet getComplement];
    [self.clockFace setNeedsDisplay];
}

- (void)changeBackgroundColor {
    float red = (200 + (arc4random() % 55)) / 255.0;
    float green = (200 + (arc4random()) % 55) / 255.0;
    float blue = (200 + (arc4random() % 55)) / 255.0;
    
    UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    [UIView animateWithDuration:6.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.backgroundView.backgroundColor = newColor;
                     }
                     completion:NULL];
}

- (void)handleOutsideTap:(UIGestureRecognizer *)recognizer {
    if ([self.tempButtons count] != 0) {
        for (UIView *subview in self.tempButtons) {
            if (subview.tag >= 100) {
                [subview removeFromSuperview];
            }
        }
        [self.tempButtons removeAllObjects];
        self.complementButton.hidden = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
