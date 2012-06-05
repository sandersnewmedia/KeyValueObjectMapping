//
// Created by Sergey Klimov on 6/4/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "DCMappingTest.h"


@implementation DCMappingTest {
    id fromObject;
    id  toObject;
    NSMutableArray *expectedMappings;
}

- (id)initWithObject:(id)_fromObject toObject:(id)_toObject
{
     if (self=[super init]) {
         fromObject = _fromObject;
         toObject = _toObject;

         expectedMappings = [NSMutableArray array];
     }
    return self;
}

- (void)expectMappingFromKeyPath:(NSString *)from toKeyPath:(NSString *)to withValue:(id)value
{
    [expectedMappings addObject:[NSArray arrayWithObjects:from,to,value, nil]];
}


- (void) verify {
    for (NSArray *expectedMapping in expectedMappings) {
        NSString *fromKeyPath = [expectedMapping objectAtIndex:0];
        NSString *toKeyPath = [expectedMapping objectAtIndex:1];
        id value = [expectedMapping objectAtIndex:2];
        if (![[toObject valueForKeyPath:toKeyPath] isEqual:value])
            [NSException raise:NSInternalInconsistencyException format:
                    @"attibute '%@' should be equal '%@' but it's equal '%@'",
                          toKeyPath, value, [toObject valueForKeyPath:toKeyPath]];


    }
}

@end