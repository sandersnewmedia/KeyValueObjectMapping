//
// Created by Sergey Klimov on 6/4/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface DCMappingTest : NSObject
- (id)initWithObject:(id)_fromObject toObject:(id)_toObject;

- (void)expectMappingFromKeyPath:(NSString *)from toKeyPath:(NSString *)to withValue:(id)value;

- (void)verify;

@end