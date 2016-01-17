//
//  KGNConcurrencyManager.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/28/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGNConcurrencyManager : NSObject

+ (KGNConcurrencyManager *) sharedInstance;

@property (nonatomic, strong) NSOperationQueue* backgroundOperationQueue;

@end
