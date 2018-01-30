//
//  LastPostCheck+CoreDataProperties.h
//  Zen Habits Reader
//
//  Created by Keegan on 10/14/15.
//  Copyright © 2015 Keegan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LastPostCheck.h"

NS_ASSUME_NONNULL_BEGIN

@interface LastPostCheck (CoreDataProperties)

@property(nullable, nonatomic, retain) NSDate *lastCheckDate;

@end

NS_ASSUME_NONNULL_END
