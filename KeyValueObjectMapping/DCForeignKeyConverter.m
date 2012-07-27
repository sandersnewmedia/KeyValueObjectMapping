//
// Created by Sergey Klimov on 5/30/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "DCForeignKeyConverter.h"
#import "DCKeyValueObjectMapping.h"
#import "DCDynamicAttribute.h"

@implementation DCForeignKeyConverter {

}
@synthesize isNested, fullSerialization, parser;




- (id) initWithParser:(DCKeyValueObjectMapping*) _parser isNested:(BOOL)_isNested fullSerialization: (BOOL)
        _fullSerialization {
    self = [super init];
    if (self) {
        parser = _parser;
        isNested = _isNested;
        fullSerialization = _fullSerialization;
    }
    return self;
}

- (id)initWithParser:(DCKeyValueObjectMapping *)_parser fullSerialization:(BOOL)_fullSerialization
{
    return [self initWithParser:_parser isNested:NO fullSerialization:_fullSerialization];
}

- (id)transformValue:(id)values forDynamicAttribute:(DCDynamicAttribute *)attribute {
    return [self transformValue:values forDynamicAttribute:attribute inObject:nil];
}


- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute inObject:(id) object
{
    if (value == (id)[NSNull null] ) {
         return nil;
    }

//    NSLog(@"encountered relationship to object of class %@ with primary key'%@'",parser.class, value);
    id result;
    if (!isNested) {
        NSString *primaryKey = value;
        result =  [parser findObjectByPrimaryKeyValue:primaryKey];
        if (!result) {
            result = [parser createObjectWithPrimaryKeyValue:primaryKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDCKeyValueObjectMappingRequestPopulationNotification object:nil
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                      parser.classToGenerate, @"class",
                                                                      value, @"primaryKey",
                                                                      result, @"object",
                                                                      object, @"relatedToObject",
                                                                               nil]];

        }

    } else {
        result = [parser parseDictionary:value];
    }
    return result;
}


- (id) serializeValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute {
    if (fullSerialization)
        return [parser serializeObject:value];
    else
        return [value valueForKeyPath:parser.primaryKeyAttribute.objectMapping.attributeName];
}

- (BOOL)canTransformValueForClass:(Class)class
{
    return YES; //fixme
}


@end
