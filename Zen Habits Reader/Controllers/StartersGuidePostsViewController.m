//
//  StartersGuidePostsViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 11/3/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "StartersGuidePostsViewController.h"
#import "PersistenceManager.h"

@interface StartersGuidePostsViewController ()

@end

@implementation StartersGuidePostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError* error;
    if (![[self fetchedResultsController] performFetch:&error])
        {
        // TODO: Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
        }
    
    [self prepareTableHeaderWithText:@"The essential posts to get you started"];
    [AnalyticsManager reportNavigationToScreen:@"Starters Guide"];
}

- (NSFetchedResultsController*) createFetchedResultsController
{
    NSManagedObjectContext *context = [[PersistenceManager sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"PostHeader" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[self startersGuidePostsPredicateFormat]];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:context sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    theFetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>)self;
    
    return theFetchedResultsController;
}

- (NSString*) startersGuidePostsPredicateFormat
    {
    NSMutableString* postsPredicate;
    NSArray* urls;
    
        urls = @[
                 @"http://zenhabits.net/breathe",
                 @"http://zenhabits.net/be-still",
                 @"http://zenhabits.net/brief-guide",
                 @"http://zenhabits.net/no-goal",
                 @"http://zenhabits.net/solitude",
                 @"http://zenhabits.net/light",
                 @"http://zenhabits.net/doing",
                 @"http://zenhabits.net/lean-tips",
                 @"http://zenhabits.net/savor",
                 @"http://zenhabits.net/no-hurry",
                 @"http://zenhabits.net/email-sanity",
                 @"http://zenhabits.net/barefoot-philosophy",
                 @"http://zenhabits.net/creative-habit",
                 @"http://zenhabits.net/the-little-but-really-useful-guide-to-creativity",
                 @"http://zenhabits.net/passionguide",
                 @"http://zenhabits.net/10-benefits-of-rising-early-and-how-to-do-it",
                 @"http://zenhabits.net/20-things-i-wish-i-had-known-when-starting-out-in-life",
                 @"http://zenhabits.net/simple-living-manifesto-72-ideas-to-simplify-your-life",
                 @"http://zenhabits.net/a-guide-to-creating-a-minimalist-home",
                 @"http://zenhabits.net/get-off-your-butt-16-ways-to-get-motivated-when-youre-in-a-slump"
                 ];

    for (NSString* url in urls)
        {
        if (!postsPredicate)
            {
            postsPredicate = [[NSMutableString alloc] initWithString:[NSString stringWithFormat: @"url == '%@'", url]];
            }
        else
            {
            [postsPredicate appendString:[NSString stringWithFormat: @" OR url == '%@'", url]];
            }
        }

    return [NSString stringWithString:postsPredicate];
    }

@end
