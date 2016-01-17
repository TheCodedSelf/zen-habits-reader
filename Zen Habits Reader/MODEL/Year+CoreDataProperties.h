//
//  Year+CoreDataProperties.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/24/15.
//  Copyright © 2015 Keegan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Year.h"

NS_ASSUME_NONNULL_BEGIN

@interface Year (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *theYear;
@property (nullable, nonatomic, retain) NSSet<Month *> *months;

@end

@interface Year (CoreDataGeneratedAccessors)

- (void)addMonthsObject:(Month *)value;
- (void)removeMonthsObject:(Month *)value;
- (void)addMonths:(NSSet<Month *> *)values;
- (void)removeMonths:(NSSet<Month *> *)values;

@end

NS_ASSUME_NONNULL_END
