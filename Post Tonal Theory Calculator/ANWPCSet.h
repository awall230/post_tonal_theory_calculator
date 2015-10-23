//
//  ANWPCSet.h
//  Post Tonal Theory Calculator
//
//  Created by Adam Waller on 7/17/15.
//  Copyright (c) 2015 Adam Waller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANWPCSet : NSObject

@property (nonatomic, readonly) unsigned long setAsInteger;
@property (nonatomic, copy, readonly) NSMutableArray *setAsArray;
@property (nonatomic, readonly) NSMutableArray *normalOrder;
@property (nonatomic, readonly) unsigned long primeForm;

// Initializers
- (instancetype) initWithInteger:(unsigned long)set;
- (instancetype) initWithArray:(NSMutableArray *)arr;

// Class methods (helper tools for doing calculations)
+ (unsigned long)transpose:(unsigned long)set ByInterval:(int)interval;
+ (unsigned long)invert:(unsigned long)set;
+ (unsigned long)getComplementOf:(unsigned long)set;
+ (void)intToBinary:(int)num;
+ (NSMutableArray *)normalOrder:(unsigned long)set;
+ (unsigned long)primeForm:(unsigned long)set;
+ (unsigned long)arrayToInteger:(NSArray *)arr;
+ (NSMutableArray *)integerToArray:(unsigned long)set;
+ (NSString *)setAsArrayToString:(NSMutableArray *)arr;

// Instance methods
- (void)addPC:(int)pc;
- (void)deletePC:(int)pc;
- (void)transposeByInterval:(int)interval;
- (void)invertAroundAxis:(int)axis;
- (void)getComplement;
- (void)updateValues;

@end
