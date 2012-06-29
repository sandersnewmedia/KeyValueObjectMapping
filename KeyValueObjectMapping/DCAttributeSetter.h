//
//  DCAttributeSetter.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCAttributeSetter : NSObject

+ (void)assignValue:(id)value forAttributeName: (NSString *)attributeName andAttributeClass: (Class) attributeClass onObject:(id)object;

@end
