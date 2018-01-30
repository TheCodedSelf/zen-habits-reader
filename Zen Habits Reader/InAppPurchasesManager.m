//
//  InAppPurchasesManager.m
//  Zen Habits Reader
//
//  Created by Keegan on 1/4/16.
//  Copyright © 2016 Keegan. All rights reserved.
//

#import "InAppPurchasesManager.h"
#import "KGNUtilities.h"

@implementation InAppPurchasesManager
NSString *const InAppPurchaseIdentifier = @"Unlock_All_Posts";
NSString *const UnlockedAllPostsPreferencesKey =
    @"UnlockedAllPostsPreferencesKey";
SKProduct *_unlockAllPostsProduct;

+ (InAppPurchasesManager *)sharedInstance {
  static InAppPurchasesManager *sharedInstance;
  if (sharedInstance == nil) {
    sharedInstance = [[InAppPurchasesManager alloc] init];
  }

  return sharedInstance;
}

- (void)initialiseInViewController:(UIViewController *)viewController {
  [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
  [self requestProductInfoInViewController:viewController];
}

- (BOOL)allPostsAreAvailable {
  NSNumber *postsAvailable = [[NSUserDefaults standardUserDefaults]
      objectForKey:UnlockedAllPostsPreferencesKey];
  return (postsAvailable != nil && postsAvailable.boolValue == YES);
}

- (void)displayPurchasesErrorAlertInViewController:
    (UIViewController *)viewController {
  UIAlertController *alertController = [UIAlertController
      alertControllerWithTitle:@"A Problem Occurred"
                       message:@"In App Purchases are not available right now."
                preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *cancelAction =
      [UIAlertAction actionWithTitle:@"OK"
                               style:UIAlertActionStyleCancel
                             handler:nil];

  [alertController addAction:cancelAction];

  [viewController presentViewController:alertController
                               animated:YES
                             completion:nil];
  alertController.view.tintColor = [KGNUtilities primaryColor];

  NSLog(@"Cannot perform In App Purchases.");
  [AnalyticsManager reportIAPUnavailable];
}

- (void)requestProductInfoInViewController:(UIViewController *)viewController {
  if ([SKPaymentQueue canMakePayments]) {
    NSSet<NSString *> *identifiers =
        [[NSSet alloc] initWithObjects:InAppPurchaseIdentifier, nil];
    SKProductsRequest *productRequest =
        [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];
    productRequest.delegate = self;
    [productRequest start];
  } else {
    [self displayPurchasesErrorAlertInViewController:viewController];
  }
}

- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response {
  if (response.products.count != 0) {
    _unlockAllPostsProduct = response.products[0];
  } else {
    NSLog(@"No products found");
  }

  if (response.invalidProductIdentifiers.count != 0) {
    NSLog(@"Invalid product identifiers!");
  }
}

- (void)presentPurchaseDialogInViewController:
    (UIViewController *)viewController {
  if (self.TransactionInProgress) {
    return;
  }
  if ([self allPostsAreAvailable]) {
    [self presentAlertWithTitle:@"Already Purchased"
                        andText:@"You have already purchased this upgrade"];
    return;
  }

  UIAlertController *alertController = [UIAlertController
      alertControllerWithTitle:@"Locked"
                       message:@"Only the Starter's Guide is available until "
                               @"you purchase the Unlock All Posts upgrade. "
                               @"Would you like to purchase it now?"
                preferredStyle:UIAlertControllerStyleAlert];

  __weak InAppPurchasesManager *weakSelf = self;

  UIAlertAction *buyAction = [UIAlertAction
      actionWithTitle:@"Buy"
                style:UIAlertActionStyleDefault
              handler:^(UIAlertAction *action) {
                if (_unlockAllPostsProduct == nil) {
                  [self displayPurchasesErrorAlertInViewController:
                            viewController];
                  return;
                }
                SKPayment *payment =
                    [SKPayment paymentWithProduct:_unlockAllPostsProduct];
                [[SKPaymentQueue defaultQueue] addPayment:payment];

                weakSelf.TransactionInProgress = true;
              }];

  UIAlertAction *cancelAction =
      [UIAlertAction actionWithTitle:@"Maybe Later"
                               style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction *action){
                             }];

  [alertController addAction:buyAction];
  [alertController addAction:cancelAction];
  [viewController presentViewController:alertController
                               animated:YES
                             completion:nil];
  alertController.view.tintColor = [KGNUtilities primaryColor];
}

- (void)restoreCompletedTransactions {
  if ([self allPostsAreAvailable]) {
    [self presentAlertWithTitle:@"Already Unlocked"
                        andText:
                            @"The Unlock All Posts upgrade is already active."];
    return;
  }
  [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue
    updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
  for (SKPaymentTransaction *transaction in transactions) {
    switch (transaction.transactionState) {
    case SKPaymentTransactionStatePurchased:
      NSLog(@"Transaction completed successfully.");
      [self presentAlertWithTitle:@"Unlock All Posts"
                          andText:@"All posts are now unlocked"];
      [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
      self.TransactionInProgress = false;
      [[NSUserDefaults standardUserDefaults]
          setObject:@YES
             forKey:UnlockedAllPostsPreferencesKey];
      [[NSUserDefaults standardUserDefaults] synchronize];
      [AnalyticsManager reportIAPPurchased];
      break;
    case SKPaymentTransactionStateFailed:
      NSLog(@"Transaction Failed");
      [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
      self.TransactionInProgress = false;
      [AnalyticsManager reportIAPFailed];
      [self presentAlertWithTitle:@"In App Purchase"
                          andText:@"I'm sorry, the purchase failed. Please try "
                                  @"again later."];
      break;
    case SKPaymentTransactionStateRestored:
      NSLog(@"Transaction restored successfully.");
      [self presentAlertWithTitle:@"Restore Purchase"
                          andText:@"Your purchase has been restored."];
      [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
      self.TransactionInProgress = false;
      [[NSUserDefaults standardUserDefaults]
          setObject:@YES
             forKey:UnlockedAllPostsPreferencesKey];
      [[NSUserDefaults standardUserDefaults] synchronize];
      [AnalyticsManager reportIAPRestored];
      break;
    case SKPaymentTransactionStateDeferred:
      NSLog(@"Transaction Deferred");
      [self presentAlertWithTitle:@"In App Purchase"
                          andText:@"The transaction is in the queue, but its "
                                  @"final status is pending external action."];
      [AnalyticsManager reportIAPDeferred];
      break;
    case SKPaymentTransactionStatePurchasing:
      NSLog(@"Transaction purchasing");
      [AnalyticsManager reportIAPPurchasing];
      break;
    default:
      break;
    }
  }
}

- (void)presentAlertWithTitle:(NSString *)title andText:(NSString *)text {
  UIAlertController *alertController =
      [UIAlertController alertControllerWithTitle:title
                                          message:text
                                   preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *cancelAction =
      [UIAlertAction actionWithTitle:@"OK"
                               style:UIAlertActionStyleCancel
                             handler:nil];

  [alertController addAction:cancelAction];

  [[UIApplication sharedApplication].windows[0].rootViewController
      presentViewController:alertController
                   animated:YES
                 completion:nil];
  alertController.view.tintColor = [KGNUtilities primaryColor];
}
@end
