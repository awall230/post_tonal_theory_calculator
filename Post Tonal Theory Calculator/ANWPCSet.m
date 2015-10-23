//
//  ANWPCSet.m
//  Post Tonal Theory Calculator
//
//  Created by Adam Waller on 7/17/15.
//  Copyright (c) 2015 Adam Waller. All rights reserved.
//

#import "ANWPCSet.h"

@interface ANWPCSet ()

// These are privately readwrite, but publicly readonly
@property (nonatomic, readwrite) unsigned long setAsInteger;
@property (nonatomic, copy, readwrite) NSMutableArray *setAsArray;
@property (nonatomic, readwrite) NSMutableArray *normalOrder;
@property (nonatomic, readwrite) unsigned long primeForm;

@end

@implementation ANWPCSet

- (instancetype)initWithArray:(NSMutableArray *)arr {
    self = [super init];
    if (self) {
        _setAsArray = arr;
        _setAsInteger = [ANWPCSet arrayToInteger:arr];
        _normalOrder = [ANWPCSet normalOrder:_setAsInteger];
        _primeForm = [ANWPCSet primeForm:_setAsInteger];
    }
    return self;
}

- (instancetype)initWithInteger:(unsigned long)set {
    return [self initWithArray:[ANWPCSet integerToArray:set]];
}

- (instancetype)init {
    return [self initWithArray:[[NSMutableArray alloc] init]];
}

- (void)setSetAsArray:(NSMutableArray *)setAsArray {
    _setAsArray = [setAsArray copy];
}

+ (unsigned long)transpose:(unsigned long)set ByInterval:(int)interval {
    interval %= 12;
    unsigned long mask = ~((1 << (12 - interval)) - 1);
    unsigned long wraparound = set & mask;	// isolate wraparound
    wraparound >>= (12 - interval);		// shift it into place
    set = set & ((1 << (12 - interval)) - 1);	// zero out leftmost n bits
    set <<= interval;	// transpose what's left
    return set | wraparound;	// combine them
}

// Performs I11
+ (unsigned long)invert:(unsigned long)set {
    unsigned long inversion = 0;
    for (int i=0; i<6; i++) {
        inversion |= (set & (1 << (6 + i))) >> (i * 2 + 1);
        inversion |= (set & (1 << (5 - i))) << (i * 2 + 1);
    }
    return inversion;
}

+ (unsigned long)getComplementOf:(unsigned long)set {
    unsigned long mask = (1<<12) - 1;
    return (~set & mask);
}

+ (NSMutableArray *)normalOrder:(unsigned long)set {
    NSMutableArray *arr;
    int interval = 0;
    unsigned long temp, normalForm = 1<<13;
    for (int i=0; i<12; i++) {
        temp = [ANWPCSet transpose:set ByInterval:i];
        if (temp < normalForm) {
            normalForm = temp;
            interval = 12-i;
        }
    }
    arr = [ANWPCSet integerToArray:normalForm];
    NSNumber *num;
    for (int i=0; i<arr.count; i++) {
        num = arr[i];
        arr[i] = [NSNumber numberWithInt:(num.intValue + interval) % 12];
    }
    return arr;
}

+ (unsigned long)TNClass:(unsigned long)set {
    unsigned long temp, normalForm = 1<<13;
    for (int i=0; i<12; i++) {
        temp = [ANWPCSet transpose:set ByInterval:i];
        if (temp < normalForm) {
            normalForm = temp;
        }
    }
    return normalForm;
}

+ (unsigned long)primeForm:(unsigned long)set {
    return MIN([ANWPCSet TNClass:set],
               [ANWPCSet TNClass:[ANWPCSet invert:set]]);
}

+ (NSMutableArray *)integerToArray:(unsigned long)set {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0; i<12; i++) {
        if ((set & (1<<i)) && 1) {	//bit is on
            [arr addObject:[NSNumber numberWithInt:i]];
        }
    }
    return arr;
}

+ (unsigned long)arrayToInteger:(NSArray *)arr {
    unsigned long set = 0;
    for (NSNumber *pc in arr) {
        set |= 1<<([pc intValue]);
    }
    return set;
}

+ (void)intToBinary:(int)num {
    int ithbit;
    for (int i=(sizeof(num)*8)-1; i>=0; i--) {
        ithbit = ((1 << i) & num) >> i;
        if (i%8 == 7)
            printf(" ");
        printf("%d", ithbit);
    }
    printf("\n");
}

+ (NSString *)setAsArrayToString:(NSMutableArray *)arr {
    if ([arr count] == 0) {
        return @"<empty>";
    }
    NSString *pcSetString = @"";
    for (NSNumber *num in arr) {
        pcSetString = [pcSetString stringByAppendingFormat:
                       @"%@ ", [NSString stringWithFormat:@"%ld", (long)[num intValue]]];
    }
    return pcSetString;
}

- (void)addPC:(int)pc {
    self.setAsInteger |= 1 << (pc%12);
    [self updateValues];
}

- (void)deletePC:(int)pc {
    self.setAsInteger &= ~(1 << (pc%12));
    [self updateValues];
}

- (void)transposeByInterval:(int)interval {
    self.setAsInteger = [ANWPCSet transpose:self.setAsInteger ByInterval:interval];
    [self updateValues];
}

- (void)invertAroundAxis:(int)axis {
    self.setAsInteger = [ANWPCSet invert:self.setAsInteger];
    // inversion is around axis 11 so must add 1 to passed axis
    [self transposeByInterval:(axis + 1)];
}

- (void)getComplement {
    self.setAsInteger = [ANWPCSet getComplementOf:self.setAsInteger];
    [self updateValues];
}

- (NSString *)description {
    NSString *str = [ANWPCSet setAsArrayToString:self.setAsArray];
    str = [str stringByAppendingFormat:@"\n%@", [ANWPCSet setAsArrayToString:self.normalOrder]];
    str = [str stringByAppendingFormat:@"\n%@", [ANWPCSet setAsArrayToString:[ANWPCSet integerToArray:self.primeForm]]];
    return str;
}

- (void)updateValues {
    self.setAsArray = [ANWPCSet integerToArray:self.setAsInteger];
    self.normalOrder = [ANWPCSet normalOrder:self.setAsInteger];
    self.primeForm = [ANWPCSet primeForm:self.setAsInteger];
}

@end
