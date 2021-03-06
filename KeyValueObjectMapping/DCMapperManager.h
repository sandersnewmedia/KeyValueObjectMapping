//
// Created by Sergey Klimov on 5/31/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import <Foundation/Foundation.h>

@class DCManagedObjectMapping;
@class NSManagedObjectContext;

@class DCMapperManager;

@protocol DCMapperManagerDelegate
- (void) mapperManager:(DCMapperManager *)mapperManager
        requestedPopulatingOfObjectOfClass:(Class)class
            primaryKey:(id) primaryKey relatedToObject:(id) relatedToObject;
@end


@interface DCMapperManager : NSObject
@property (unsafe_unretained) id<DCMapperManagerDelegate> delegate;
- (id)initWithConfiguration:(NSDictionary *)configurationDictionary;

- (id)initWithConfiguration:(NSDictionary *)configurationDictionary andManagedObjectContext:(NSManagedObjectContext
*)_context;
- (id)mapperForClass:(Class)class;

- (DCManagedObjectMapping *)managedMapperForClass:(Class)class;

- (id)parse:(id)dictionaryOrArray ForClass:(Class)class;
- (id)parse:(id)dictionaryOrArray ForClass:(Class)class originalObject:(id)originalObject;


- (id)serialize:(id)objectOrArray;

- (NSString *)primaryKeyAttributeNameForClass:(Class)class;
@end