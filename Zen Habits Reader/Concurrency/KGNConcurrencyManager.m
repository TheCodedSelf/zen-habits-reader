//
//  KGNConcurrencyManager.m
//  Zen Habits Reader
//
//  Created by Keegan on 9/28/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "KGNConcurrencyManager.h"

@implementation KGNConcurrencyManager

@synthesize backgroundOperationQueue = _backgroundOperationQueue;

+ (KGNConcurrencyManager *) sharedInstance
    {
    static KGNConcurrencyManager *sharedInstance;
    if (sharedInstance == nil)
        {
        sharedInstance = [[KGNConcurrencyManager alloc] init];
        }
    
    return sharedInstance;
    }

- (NSOperationQueue *) backgroundOperationQueue
    {
    if (!_backgroundOperationQueue)
        {
            _backgroundOperationQueue = [[NSOperationQueue alloc] init];
        }
        
    return _backgroundOperationQueue;
    }

@end
