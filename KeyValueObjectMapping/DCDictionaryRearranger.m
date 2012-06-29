//
//  DCDictionaryRearranger.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCDictionaryRearranger.h"
#import "DCPropertyAggregator.h"

@implementation DCDictionaryRearranger


+ (NSDictionary *) rearrangeDictionary: (NSDictionary *) dictionary forAggregators: (NSMutableArray *) aggregators {
    aggregators = [NSMutableArray arrayWithArray:[[aggregators reverseObjectEnumerator] allObjects]];
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    if(aggregators && [aggregators count] > 0){
        for(int i=[aggregators count] - 1; i >= 0; --i){
            DCPropertyAggregator *aggregator = [aggregators objectAtIndex:(NSUInteger)i];
            [aggregators removeObject:aggregator];
            NSDictionary *aggregatedValues = [aggregator aggregateKeysOnDictionary:mutableDictionary];
            [mutableDictionary setValue:aggregatedValues forKey:aggregator.attribute];
        }
    }
    return mutableDictionary;
}

@end
