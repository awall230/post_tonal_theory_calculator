//
//  ANWClockFaceView.m
//  Post Tonal Theory Calculator
//
//  Created by Adam Waller on 7/16/15.
//  Copyright (c) 2015 Adam Waller. All rights reserved.
//

#import "ANWClockFaceView.h"
#import "ANWPitchClassView.h"
#import "ANWSetCalculatorViewController.h"

@interface ANWClockFaceView ()

@end

@implementation ANWClockFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.currentPCSet = [[ANWPCSet alloc] init];
        
        CGRect bounds = self.bounds;
        _centerPoint = CGPointMake(bounds.size.width * 0.5, bounds.size.height * 0.5);
        _radius = MIN(bounds.size.width, bounds.size.height) / 2.5;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIBezierPath *circle = [[UIBezierPath alloc] init];
    
    [circle addArcWithCenter:self.centerPoint
                      radius:self.radius
                  startAngle:0
                    endAngle:M_PI * 2.0
                   clockwise:YES];
    [circle stroke];
    
    for (ANWPitchClassView *pcView in self.pitchClassViews) {
        pcView.color = [UIColor redColor];
    }
    
    for (NSNumber *pc in self.currentPCSet.setAsArray) {
        ANWPitchClassView *pcView = [self.pitchClassViews objectAtIndex:[pc intValue]];
        pcView.color = [UIColor blueColor];
    }
    
    self.originalSetLabel.text = [NSString stringWithFormat:@"Original Set:     %@",
                                  [ANWPCSet setAsArrayToString:self.currentPCSet.setAsArray]];
    self.normalOrderLabel.text = [NSString stringWithFormat:@"Normal Order:  %@",
                                  [ANWPCSet setAsArrayToString:self.currentPCSet.normalOrder]];
    self.primeFormLabel.text = [NSString stringWithFormat:@"Prime Form:     %@",
                                [ANWPCSet setAsArrayToString:[ANWPCSet integerToArray:self.currentPCSet.primeForm]]];
    
    // If there are at least 2 pcs, connect them with lines
    if ([self.currentPCSet.setAsArray count] > 1)
        [self drawLines];
    
    
}

// Connects pc "dots" into shape on clock face
- (void)drawLines {
    if ([self.pitchClassViews count] == 0)
        return;
    
    NSMutableArray *arr = [self.currentPCSet.setAsArray copy];
    arr = (NSMutableArray *)[arr sortedArrayUsingSelector:@selector(compare:)];
    UIBezierPath *line = [[UIBezierPath alloc] init];
    ANWPitchClassView *startView, *destinationView;
    CGPoint startPoint, destinationPoint;
    
    startView = self.pitchClassViews[[arr[0] integerValue]];
    startPoint = startView.center;
    [line moveToPoint:startPoint];
    
    for (int i=1; i<[arr count]; i++) {
        destinationView = self.pitchClassViews[[arr[i] integerValue]];
        destinationPoint = destinationView.center;
        [line addLineToPoint:destinationPoint];
    }
    
    [line addLineToPoint:startPoint];
    
    [line stroke];
    
}


@end
