//
//  PostLoader.m
//  Zen Habits Reader
//
//  Created by Keegan on 9/24/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "PostLoader.h"
#import "KGNConcurrencyManager.h"
#import "KGNUtilities.h"
#import "LoadingManager.h"

@implementation PostLoader
NSString *const firstCheckDate = @"firstCheckDate";
NSString *const populatedKey = @"populatedKey";

+ (void)loadPosts {
  NSNumber *isPopulated =
      [[NSUserDefaults standardUserDefaults] objectForKey:populatedKey];
  if (isPopulated == nil)
  {
    PostHeader *mostRecentPost;
    mostRecentPost = [[PersistenceManager sharedInstance] getMostRecentPost];
    NSInvocationOperation *firstDownloadOperation =
        [[NSInvocationOperation alloc]
            initWithTarget:self
                  selector:@selector(downloadAllPostsAfterDate:)
                    object:mostRecentPost.date];
    firstDownloadOperation.completionBlock = ^{
      NSLog(@"All posts: %lu",
            (unsigned long)[[PersistenceManager sharedInstance] allPostHeaders].count);
      [[NSUserDefaults standardUserDefaults] setObject:[NSDate date]
                                                forKey:firstCheckDate];
      [[NSUserDefaults standardUserDefaults]
          setObject:@YES
             forKey:populatedKey];
      [[NSUserDefaults standardUserDefaults] synchronize];
    };

    [[KGNConcurrencyManager sharedInstance].backgroundOperationQueue
        addOperation:firstDownloadOperation];
  } else {
    [self checkForNewPosts];
  }
}

+ (BOOL)downloadAllPostsAfterDate:(NSDate *)dateToCheck {
  dispatch_async(dispatch_get_main_queue(), ^{
    [[LoadingManager sharedInstance] setIsBusyLoading:YES];
  });

  BOOL foundNewPosts;
  NSDate *dateOfFirstCheck;
  NSString *currentYear;
  NSString *currentMonth;
  BOOL isNew;

  dateOfFirstCheck = (NSDate *)[[NSUserDefaults standardUserDefaults]
      objectForKey:firstCheckDate];

  foundNewPosts = false;

  NSURL *archiveUrl =
      [NSURL URLWithString:@"http://www.zenhabits.net/archives"];
  NSData *archiveHtmlData = [NSData dataWithContentsOfURL:archiveUrl];

  TFHpple *htmlParser = [TFHpple hppleWithHTMLData:archiveHtmlData];

  NSString *tableRowsXpath = @"//table[@id='arc']/./tr";
  NSArray *tableRowNodes = [htmlParser searchWithXPathQuery:tableRowsXpath];

  for (TFHppleElement *element in tableRowNodes) {
    NSArray *thChildren = [element childrenWithTagName:@"th"];

    NSArray *aChildrenOftd;
    NSString *thText;
    NSString *currentDay;
    NSDate *postDate;

    if (thChildren.count > 0) {
      if (thChildren.count > 1) {
        NSLog(@"There should only be one child in this array!");
      }

      thText = [thChildren[0] content];
    } else {
      NSLog(@"No th!");
    }

    // Does this row define the year?
    if ([[(element.attributes)[@"class"] lowercaseString]
            isEqual:@"year"] &&
        [element hasChildren]) {
      currentYear = [thChildren[0] content];
      continue;
    }

    NSArray *tdChildren = [element childrenWithTagName:@"td"];

    if (tdChildren.count < 1) {
      NSLog(@"Found a row without td!");
      continue;
    } else if (tdChildren.count > 1) {
      NSLog(@"Found a row with more than one td!");
    }

    TFHppleElement *tdChild = tdChildren[0];
    aChildrenOftd = [tdChild childrenWithTagName:@"a"];

    // Does this row define the month?
    if (aChildrenOftd.count < 1) {
      currentMonth = thText;
      continue;
    }

    if ([thText isEqualToString:@""]) {
      NSLog(@"thText should not be empty! Looking for a post day.");
      continue;
    }

    currentDay = thText;

    isNew = NO;
    postDate = [KGNUtilities
        dateFromFriendlyString:[NSString
                                   stringWithFormat:@"%@ %@ %@", currentDay,
                                                    currentMonth, currentYear]];

    if (dateToCheck != nil) {
      if ([[postDate earlierDate:dateToCheck] isEqualToDate:postDate]) {
        continue;
      }
    }

    if (dateOfFirstCheck != nil && [[dateOfFirstCheck earlierDate:postDate]
                                       isEqualToDate:dateOfFirstCheck]) {
      isNew = YES;
    }

    TFHppleElement *link = aChildrenOftd[0];

    NSString *postID = (tdChild.attributes)[@"id"];
    NSString *title = link.content;
    NSString *url = (link.attributes)[@"href"];

    [[PersistenceManager sharedInstance] createPostHeaderWithTitle:title
                                                            andUrl:url
                                                            andDay:currentDay
                                                          andMonth:currentMonth
                                                           andYear:currentYear
                                                          andIsNew:isNew
                                                         andIsRead:NO
                                                         andPostID:postID];
    foundNewPosts = true;
  }

  [[PersistenceManager sharedInstance] saveContext];

  dispatch_async(dispatch_get_main_queue(), ^{
    [[LoadingManager sharedInstance] removeCurrentLoadingScreen];
    [[LoadingManager sharedInstance] setIsBusyLoading:NO];
  });

  return foundNewPosts;
}

+ (NSString *)getPostBodyHTMLFromPostUrl:(NSString *)postURL
                                andTitle:(NSString *)postTitle {
  NSData *postHtmlData =
      [NSData dataWithContentsOfURL:[NSURL URLWithString:postURL]];

  if (!postHtmlData) {
    return nil;
  }

  TFHpple *htmlParser = [TFHpple hppleWithHTMLData:postHtmlData];

  NSString *postBodyXPath = @"//div[@class='post']";
  NSArray *postNodes = [htmlParser searchWithXPathQuery:postBodyXPath];

  if (postNodes.count < 1) {
    NSLog(@"Could not find post body! URL: %@", postURL);
    return nil;
  }

  TFHppleElement *postBody = postNodes[0];

  NSString *postString = [NSString
      stringWithFormat:@"<h2>%@</h2></br>%@", postTitle, postBody.raw];

  NSString *headXPath = @"//head";
  NSArray *headNodes = [htmlParser searchWithXPathQuery:headXPath];

  if (headNodes.count < 1) {
    NSLog(@"Could not find post head! URL: %@", postURL);
  } else {
    TFHppleElement *headBody = headNodes[0];
    NSString *head = [NSString stringWithString:headBody.raw];
    head = [head
        stringByReplacingOccurrencesOfString:@"</head>"
                                  withString:@"<style>p {margin-left: 10px; "
                                             @"margin-right: 10px; font-size: "
                                             @"17px;} h2 {margin-left: 5px; "
                                             @"margin-right: 5px; "
                                             @"margin-bottom: 0px; "
                                             @"text-align: "
                                             @"center;}</style></head>"];
    postString = [NSString stringWithFormat:@"%@%@", head, postString];
  }

  NSString *subHeaderXPath = @"//h6";
  NSArray *subHeaderNodes = [htmlParser searchWithXPathQuery:subHeaderXPath];

  if (subHeaderNodes.count < 1) {
    NSLog(@"Could not find post subheader! URL: %@", postURL);
  } else {
    TFHppleElement *subHeaderElement = subHeaderNodes[0];
    NSString *subHeader = [NSString stringWithString:subHeaderElement.raw];
    postString = [postString stringByReplacingOccurrencesOfString:subHeader
                                                       withString:@""];
  }

  return postString;
}

+ (void)checkForNewPosts {
  PostHeader *mostRecentPost;
  NSDate *mostRecentPostDate;

  mostRecentPost = [[PersistenceManager sharedInstance] getMostRecentPost];
  mostRecentPostDate = mostRecentPost
                           ? mostRecentPost.date
                           : [NSDate dateWithTimeIntervalSince1970:0];

  if (!mostRecentPost) {
    NSLog(@"*** No most recent post! ***");
  }

  if ([KGNUtilities isDateBeforeToday:mostRecentPostDate]) {
    NSInvocationOperation *checkNewPostsOperation =
        [[NSInvocationOperation alloc]
            initWithTarget:self
                  selector:@selector(downloadAllPostsAfterDate:)
                    object:mostRecentPostDate];

    [[KGNConcurrencyManager sharedInstance].backgroundOperationQueue
        addOperation:checkNewPostsOperation];
  }
}

@end
