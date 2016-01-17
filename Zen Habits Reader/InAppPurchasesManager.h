//
//  InAppPurchasesManager.h
//  Zen Habits Reader
//
//  Created by Keegan on 1/4/16.
//  Copyright © 2016 Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface InAppPurchasesManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property BOOL TransactionInProgress;

+ (InAppPurchasesManager *) sharedInstance;
- (void) initialiseInViewController:(UIViewController*)viewController;
- (BOOL) allPostsAreAvailable;
- (void) presentPurchaseDialogInViewController: (UIViewController*)viewController;
- (void)restoreCompletedTransactions;

@end
