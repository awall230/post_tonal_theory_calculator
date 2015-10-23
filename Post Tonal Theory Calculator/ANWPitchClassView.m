//
//  ANWPitchClassView.m
//  Post Tonal Theory Calculator
//
//  Created by Adam Waller on 7/16/15.
//  Copyright (c) 2015 Adam Waller. All rights reserved.
//

#import "ANWPitchClassView.h"
#import "ANWClockFaceView.h"


@implementation ANWPitchClassView

- (instancetype)initWithFrame:(CGRect)frame PC:(NSInteger)pc {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _centerPoint = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        _pc = pc;
        _color = [UIColor redColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame
                            PC:-1];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect bounds = self.bounds;
    float radius = 0.95 * MIN(bounds.size.width, bounds.size.height) / 2.0;
    
    UIBezierPath *circle = [[UIBezierPath alloc] init];
    [circle addArcWithCenter:self.centerPoint
                      radius:radius
                  startAngle:0.0
                    endAngle:M_PI * 2.0
                   clockwise:YES];
    
    [self.color setFill];
    [circle fill];
        
    NSString *pcString = [NSString stringWithFormat:@"%ld", (long)self.pc];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:radius];
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor whiteColor] };
    
    CGRect textBox = CGRectMake(bounds.origin.x, bounds.origin.y + radius/2.4,
                                bounds.size.width, bounds.size.height * 0.75);  //seems like it should be radius/2.0
    
    [pcString drawInRect:textBox withAttributes:attributes];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Add to current pc set in clockFaceView
    ANWClockFaceView *parent = (ANWClockFaceView *)self.superview;
    if ([parent.currentPCSet.setAsArray containsObject:[NSNumber numberWithInt:(int)self.pc]]) {
        [parent.currentPCSet deletePC:(int)self.pc];
    }
    else {
        [parent.currentPCSet addPC:(int)self.pc];
    }
    [parent setNeedsDisplay];
}


@end
