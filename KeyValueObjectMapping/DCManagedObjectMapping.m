//
// Created by Sergey Klimov on 5/29/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "DCManagedObjectMapping.h"
#import "DCDynamicAttribute.h"
#import "Turn.h"


@implementation DCManagedObjectMapping {
    NSManagedObjectContext *context;

}
+ (DCManagedObjectMapping *)mapperForClass:(Class)classToGenerate andConfiguration:(DCParserConfiguration *)
        configuration
        andManagedObjectContext:(NSManagedObjectContext *)context
{
    return [[self alloc] initWithClass:classToGenerate forConfiguration:configuration
               andManagedObjectContext:context];
}


- (id) initWithClass: (Class) _classToGenerate forConfiguration: (DCParserConfiguration *) _configuration
        andManagedObjectContext: (NSManagedObjectContext *)_context {
    self=[self initWithClass:_classToGenerate forConfiguration:_configuration];
    if (self) {
         context=_context;
    }
    return self;
}

- (id)createObjectWithPrimaryKeyValue:(id)primaryKeyValue
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self.classToGenerate)
                                              inManagedObjectContext:context];
    NSManagedObject * object = [[self.classToGenerate alloc] initWithEntity:entity
                     insertIntoManagedObjectContext:context] ;
    [object setValue:primaryKeyValue forKey:self.primaryKeyAttribute.objectMapping.attributeName];
    return object;
}

// Helpers for debugging duplicate objs w/ same primary key
- (void)deleteEntitiesInCollection:(NSArray *)collection
{
    for (NSManagedObject *obj in collection) {
        TFLog(@"(findObjectByPrimaryKeyValue): deleting: %@", obj);
        [obj deleteInContext:context];
    }
}

- (id)returnWithTFLog:(id)returnValue
{
    TFLog(@"(findObjectByPrimaryKeyValue): returning: %@", returnValue);
    return returnValue;
}

- (id)findObjectByPrimaryKeyValue:(id)primaryKeyValue
{
    DCDynamicAttribute * primaryKeyAttribute = [self primaryKeyAttribute];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", primaryKeyAttribute.objectMapping
                                                                                   .attributeName, primaryKeyValue];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(self.classToGenerate)];
    request.predicate = predicate;

    NSError *error;
    NSMutableArray *objects = [NSMutableArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }

    if (objects.count > 1) {
        TFLog(@"(findObjectByPrimaryKeyValue): detected %i %@s in context with %@: %@ --deciding what to do",
                objects.count,
                NSStringFromClass(self.classToGenerate),
                primaryKeyAttribute.objectMapping.attributeName,
                primaryKeyValue);
        TFLog(@"(findObjectByPrimaryKeyValue): objects: %@", objects);

        // Separate Turn objects that have turnPrev from array of all objects
        NSMutableArray *turnsWithTurnPrev = [[NSMutableArray alloc] init];

        for (NSManagedObject *obj in objects) {
            if ([obj isKindOfClass:[Turn class]]) {
                if ([(Turn *)obj turnPrev]) {
                    [turnsWithTurnPrev addObject:obj];
                }
            }
        }

        for (Turn *turn in turnsWithTurnPrev) {
            if ([objects containsObject:turn]) {
                [objects removeObject:turn];
            }
        }

        // Make decision about which Turn to return
        if (turnsWithTurnPrev.count == 1) {
            TFLog(@"(findObjectByPrimaryKeyValue): Scenario 1: one duplicate Turn has turnPrev --returing this, deleting all others");
            [self deleteEntitiesInCollection:objects];
            [self returnWithTFLog:[turnsWithTurnPrev lastObject]];
        }
        
        if (turnsWithTurnPrev.count == 0) {
            TFLog(@"(findObjectByPrimaryKeyValue): Scenario 2: no duplicate Turns have turnPrev --returning lastObject, deleting all others");
            NSManagedObject *objectToReturn = [objects lastObject];
            [objects removeLastObject];
            
            [self deleteEntitiesInCollection:objects];
            [self returnWithTFLog:objectToReturn];
        }
        
        if (turnsWithTurnPrev.count > 1) {
            TFLog(@"(findObjectByPrimaryKeyValue): Scenario 3: more than one duplicate Turn has turnPrev --returning last of these, deleting all others");
            Turn *turnToReturn = [turnsWithTurnPrev lastObject];
            [turnsWithTurnPrev removeLastObject];
            
            [self deleteEntitiesInCollection:turnsWithTurnPrev];
            [self deleteEntitiesInCollection:objects];
            [self returnWithTFLog:turnToReturn];
        }
    }

    return [objects lastObject];
}

@end