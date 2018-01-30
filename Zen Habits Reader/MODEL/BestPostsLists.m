//
//  BestPostsLists.m
//  Zen Habits Reader
//
//  Created by Keegan on 11/9/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "BestPostsLists.h"

@implementation BestPostsLists

+ (int) mostRecentPostYear
    {
    return 2015;
    }

+ (NSString*) predicateForYear: (NSInteger) year
{
 NSArray* years = [BestPostsLists allYears];
 return years[[BestPostsLists mostRecentPostYear] - year];
}

+ (NSArray*) allYears
    {
        static NSArray* allYears;
        
        if (!allYears)
            {
                allYears = @[[self bestOf2015], [self bestOf2014], [self bestOf2013], [self bestOf2012], [self bestOf2011], [self bestOf2010], [self bestOf2009], [self bestOf2008], [self bestOf2007]];
            }
             return allYears;
    }

+ (NSString*) bestOf2007
    {
        NSArray* urls;
        urls = @[
                 @"http://zenhabits.net/email-zen-clear-out-your-inbox",
                 @"http://zenhabits.net/zen-mind-how-to-declutter",
                 @"http://zenhabits.net/baby-makes-eight-raising-six-kids-part",
                 @"http://zenhabits.net/steps-to-permanently-clear-desk",
                 @"http://zenhabits.net/top-20-motivation-hacks-overview",
                 @"http://zenhabits.net/how-not-to-multitask-work-simpler-and",
                 @"http://zenhabits.net/edit-your-life-part-1-commitments",
                 @"http://zenhabits.net/how-i-ended-my-love-affair-with-credit",
                 @"http://zenhabits.net/purpose-your-day-most-important-task",
                 @"http://zenhabits.net/the-art-of-doing-nothing",
                 @"http://zenhabits.net/10-habits-to-develop-for-financial",
                 @"http://zenhabits.net/cheap-but-great-dates",
                 @"http://zenhabits.net/how-to-not-do-everything-on-your-to-do-list",
                 @"http://zenhabits.net/zen-to-done-ztd-the-ultimate-simple-productivity-system",
                 @"http://zenhabits.net/big-rocks-first-double-your-productivity-this-week",
                 @"http://zenhabits.net/inbox-master-get-all-your-inboxes-to-zero-and-have-fewer-inboxes",
                 @"http://zenhabits.net/top-15-diet-hacks",
                 @"http://zenhabits.net/handbook-for-life-52-tips-for-happiness-and-productivity",
                 @"http://zenhabits.net/beginners-guide-to-running",
                 @"http://zenhabits.net/how-to-be-a-great-dad-12-awesome-tips",
                 @"http://zenhabits.net/10-benefits-of-rising-early-and-how-to-do-it",
                 @"http://zenhabits.net/ways-to-be-romantic-on-the-cheap",
                 @"http://zenhabits.net/a-guide-to-cultivating-compassion-in-your-life-with-7-practices",
                 @"http://zenhabits.net/eliminate-all-but-the-absolute-essential-tasks",
                 @"http://zenhabits.net/the-getting-things-done-gtd-faq",
                 @"http://zenhabits.net/a-guide-to-escaping-materialism-and-finding-happiness",
                 @"http://zenhabits.net/how-to-actually-execute-your-to-do-list-or-why-writing-it-down-doesnt-actually-get-it-done",
                 @"http://zenhabits.net/5-powerful-reasons-to-eat-slower",
                 @"http://zenhabits.net/18-practical-tips-for-living-the-golden-rule",
                 @"http://zenhabits.net/21-strategies-for-creating-an-emergency-fund-and-why-its-critical",
                 @"http://zenhabits.net/a-guide-to-creating-a-minimalist-home",
                 @"http://zenhabits.net/how-to-become-a-vegetarian-the-easy-way",
                 @"http://zenhabits.net/the-cheapskate-guide-50-tips-for-frugal-living",
                 @"http://zenhabits.net/get-off-your-butt-16-ways-to-get-motivated-when-youre-in-a-slump",
                 @"http://zenhabits.net/haiku-productivity-the-fine-art-of-limiting-yourself-to-the-essential",
                 @"http://zenhabits.net/simple-living-manifesto-72-ideas-to-simplify-your-life",
                 @"http://zenhabits.net/haiku-productivity-limit-your-work-week",
                 @"http://zenhabits.net/how-to-accept-criticism-with-grace-and-appreciation",
                 @"http://zenhabits.net/fiscal-fitness-eliminate-debt-with-10-successful-diet-principles",
                 @"http://zenhabits.net/15-great-decluttering-tips",
                 @"http://zenhabits.net/hassle-free-weight-loss-the-zen-habits-meal-plan",
                 @"http://zenhabits.net/31-ways-to-motivate-yourself-to-exercise",
                 @"http://zenhabits.net/haiku-productivity-limit-your-projects-to-achieve-completion",
                 @"http://zenhabits.net/10-simple-sure-fire-ways-to-make-today-your-best-day-ever",
                 @"http://zenhabits.net/unproductivity-8-fantabulous-ways-to-make-the-most-of-your-laziest-days",
                 @"http://zenhabits.net/faith-in-humanity-how-to-bring-people-closer-and-restore-kindness",
                 @"http://zenhabits.net/the-10-key-actions-that-finally-got-me-out-of-debt-or-why-living-frugally-is-only-part-of-the-solution",
                 @"http://zenhabits.net/wake-up-a-guide-to-living-your-life-consciously",
                 @"http://zenhabits.net/25-killer-actions-to-boost-your-self-confidence",
                 @"http://zenhabits.net/15-cant-miss-ways-to-declutter-your-mind",
                 @"http://zenhabits.net/14-stress-free-ways-to-kick-weight-loss-in-the-butt"
                 ];
        
        return [BestPostsLists predicateWithUrls:urls];
    }

+ (NSString*) bestOf2008
    {
        NSArray* urls;
        urls = @[
                 @"http://zenhabits.net/20-things-i-wish-i-had-known-when-starting-out-in-life",
                 @"http://zenhabits.net/minimalist-fitness-how-to-get-in-lean-shape-with-little-or-no-equipment",
                 @"http://zenhabits.net/30-things-to-do-to-keep-from-getting-bored-out-of-your-skull-at-work",
                 @"http://zenhabits.net/5-amazing-mac-apps-for-getting-things-done-plus-a-custom-rigged-setup",
                 @"http://zenhabits.net/the-four-laws-of-simplicity-and-how-to-apply-them-to-life",
                 @"http://zenhabits.net/the-lazy-mans-guide-to-getting-things-done",
                 @"http://zenhabits.net/21-easy-hacks-to-simplify-your-life",
                 @"http://zenhabits.net/the-minimalists-guide-to-simple-housework",
                 @"http://zenhabits.net/20-money-hacks-tips-and-tricks-to-improve-your-finances",
                 @"http://zenhabits.net/17-fitness-truths-to-get-you-in-great-shape",
                 @"http://zenhabits.net/18-five-minute-decluttering-tips-to-start-conquering-your-mess",
                 @"http://zenhabits.net/top-5-most-inspirational-videos-on-youtube",
                 @"http://zenhabits.net/how-to-go-from-sedentary-to-running-in-five-steps",
                 @"http://zenhabits.net/how-i-paid-off-35000-in-debt-and-how-you-can-too",
                 @"http://zenhabits.net/the-seven-deadly-sins-of-a-relationship",
                 @"http://zenhabits.net/a-12-step-program-to-eating-healthier-than-ever-before",
                 @"http://zenhabits.net/12-new-rules-of-working-you-should-embrace-today",
                 @"http://zenhabits.net/the-ultimate-guide-to-motivation-how-to-achieve-any-goal",
                 @"http://zenhabits.net/7-little-habits-that-can-change-your-life-and-how-to-form-them",
                 @"http://zenhabits.net/7-powerful-steps-to-overcoming-resistance-and-actually-getting-stuff-done",
                 @"http://zenhabits.net/20-amazing-and-essential-non-fiction-books-to-enrich-your-library",
                 @"http://zenhabits.net/25-ways-to-simplify-your-life-with-kids",
                 @"http://zenhabits.net/open-source-blogging-feel-free-to-steal-my-content",
                 @"http://zenhabits.net/the-minimalists-guide-to-fighting-and-beating-clutter-entropy",
                 @"http://zenhabits.net/12-practical-steps-for-learning-to-go-with-the-flow"
                 ];
        
        return [BestPostsLists predicateWithUrls:urls];
    }

+ (NSString*) bestOf2009
{
    NSArray* urls;
    urls = @[
             @"http://zenhabits.net/breathe",
             @"http://zenhabits.net/the-habit-change-cheatsheet-29-ways-to-successfully-ingrain-a-behavior",
             @"http://zenhabits.net/feel-the-fear-and-do-it-anyway-or-the-privatization-of-the-english-language",
             @"http://zenhabits.net/do-interesting-things",
             @"http://zenhabits.net/the-get-started-now-guide-to-becoming-self-employed",
             @"http://zenhabits.net/the-little-but-really-useful-guide-to-creativity",
             @"http://zenhabits.net/love-life-not-stuff",
             @"http://zenhabits.net/the-simple-fitness-rules",
             @"http://zenhabits.net/the-lazy-manifesto-do-less-then-do-even-less",
             @"http://zenhabits.net/the-short-but-powerful-guide-to-finding-your-passion",
             @"http://zenhabits.net/passionguide",
             @"http://zenhabits.net/your-life-simplified",
             @"http://zenhabits.net/a-guide-to-beating-the-fears-that-are-holding-you-back",
             @"http://zenhabits.net/ultra-simple-3-step-productivity-system-for-getting-amazing-things-done",
             @"http://zenhabits.net/minimalist-gmail-how-to-get-rid-of-the-non-essentials",
             @"http://zenhabits.net/the-single-secret-to-making-2009-your-best-year-ever",
             @"http://zenhabits.net/a-simple-guide-to-keeping-your-counters-clutter-free",
             @"http://zenhabits.net/the-10-essential-rules-for-slowing-down-and-enjoying-life-more",
             @"http://zenhabits.net/how-to-create-a-minimalist-computer-experience",
             @"http://zenhabits.net/the-little-rules-of-action",
             @"http://zenhabits.net/8-ways-doing-less-can-transform-your-work-life",
             @"http://zenhabits.net/the-mindfulness-guide-for-the-super-busy-how-to-live-life-to-the-fullest",
             @"http://zenhabits.net/the-minimalist-principle-omit-needless-things",
             @"http://zenhabits.net/get-less-done-stop-being-productive-and-enjoy-yourself",
             @"http://zenhabits.net/10-essential-money-skills-for-a-bad-economy",
             @"http://zenhabits.net/dead-simple-guide-to-beating-procrastination",
             @"http://zenhabits.net/how-to-live-a-better-life-with-less",
             @"http://zenhabits.net/the-only-way-to-become-amazingly-great-at-something",
             @"http://zenhabits.net/55-ways-to-get-more-energy",
             @"http://zenhabits.net/20-motivation-questions"
             ];
    
    return [BestPostsLists predicateWithUrls:urls];
}

+ (NSString*) bestOf2010
{
    NSArray* urls;
    urls = @[
             @"http://zenhabits.net/perfect",
             @"http://zenhabits.net/solitude",
             @"http://zenhabits.net/bah",
             @"http://zenhabits.net/savor",
             @"http://zenhabits.net/no-goal",
             @"http://zenhabits.net/anti-success",
             @"http://zenhabits.net/doing",
             @"http://zenhabits.net/light",
             @"http://zenhabits.net/space",
             @"http://zenhabits.net/creative-habit",
             @"http://zenhabits.net/simple-morning",
             @"http://zenhabits.net/brief-guide",
             @"http://zenhabits.net/kill-your-to-do-list",
             @"http://zenhabits.net/no-hurry",
             @"http://zenhabits.net/kindfully",
             @"http://zenhabits.net/achieving",
             @"http://zenhabits.net/300-word-positivity",
             @"http://zenhabits.net/procrastination",
             @"http://zenhabits.net/tao-of-productivity",
             @"http://zenhabits.net/get-inspired"
             ];
    
    return [BestPostsLists predicateWithUrls:urls];
    }

+ (NSString*) bestOf2011
{
    NSArray* urls;
    urls = @[
             @"http://zenhabits.net/4",
             @"http://zenhabits.net/tada",
             @"http://zenhabits.net/38",
             @"http://zenhabits.net/joyfear",
             @"http://zenhabits.net/begin",
             @"http://zenhabits.net/done",
             @"http://zenhabits.net/create",
             @"http://zenhabits.net/voice",
             @"http://zenhabits.net/half",
             @"http://zenhabits.net/free",
             @"http://zenhabits.net/read"
             ];
    
    return [BestPostsLists predicateWithUrls:urls];
}

+ (NSString*) bestOf2012
{
    NSArray* urls;
    urls = @[
             @"http://zenhabits.net/shaken",
             @"http://zenhabits.net/39th",
             @"http://zenhabits.net/plants",
             @"http://zenhabits.net/full-screen",
             @"http://zenhabits.net/simplify",
             @"http://zenhabits.net/live",
             @"http://zenhabits.net/starting",
             @"http://zenhabits.net/love-it",
             @"http://zenhabits.net/create-silence",
             @"http://zenhabits.net/inspired",
             @"http://zenhabits.net/great-dad",
             @"http://zenhabits.net/empty",
             @"http://zenhabits.net/pause",
             @"http://zenhabits.net/unschool",
             @"http://zenhabits.net/the-way",
             ];
    
    return [BestPostsLists predicateWithUrls:urls];
}

+ (NSString*) bestOf2013
{
    NSArray* urls;
    urls = @[
             @"http://zenhabits.net/less",
             @"http://zenhabits.net/iloveyou",
             @"http://zenhabits.net/aol",
             @"http://zenhabits.net/disciplined",
             @"http://zenhabits.net/uncareer",
             @"http://zenhabits.net/be",
             @"http://zenhabits.net/failed",
             @"http://zenhabits.net/unknowing",
             @"http://zenhabits.net/mmm",
             @"http://zenhabits.net/lyrical",
             @"http://zenhabits.net/discomfort",
             @"http://zenhabits.net/sticky",
             @"http://zenhabits.net/contentment",
             @"http://zenhabits.net/startup",
             @"http://zenhabits.net/quiet",
             @"http://zenhabits.net/comparing",
             @"http://zenhabits.net/calm",
             @"http://zenhabits.net/toolset",
             @"http://zenhabits.net/manly"
             ];
    
    return [BestPostsLists predicateWithUrls:urls];
}

+ (NSString*) bestOf2014
{
     NSArray* urls;
     urls = @[
             @"http://zenhabits.net/notes",
             @"http://zenhabits.net/2014-review",
             @"http://zenhabits.net/respect",
             @"http://zenhabits.net/realization",
             @"http://zenhabits.net/failproof",
             @"http://zenhabits.net/fears",
             @"http://zenhabits.net/mastery",
             @"http://zenhabits.net/face",
             @"http://zenhabits.net/fatherhood",
             @"http://zenhabits.net/opt-out",
             @"http://zenhabits.net/career",
             @"http://zenhabits.net/vegan",
             @"http://zenhabits.net/writer",
             @"http://zenhabits.net/fear-not",
             @"http://zenhabits.net/36lessons",
             @"http://zenhabits.net/conduct",
             @"http://zenhabits.net/child"
             ];
    
     return [BestPostsLists predicateWithUrls:urls];
}

+ (NSString*) bestOf2015
    {
    NSArray* urls;
    urls = @[
             @"http://zenhabits.net/scary-20s",
             @"http://zenhabits.net/miraculous",
             @"http://zenhabits.net/unconditional",
             @"http://zenhabits.net/distraction",
             @"http://zenhabits.net/right",
             @"http://zenhabits.net/anti-bucket",
             @"http://zenhabits.net/reality",
             @"http://zenhabits.net/frustrate",
             @"http://zenhabits.net/sucky",
             @"http://zenhabits.net/healthy"
             ];
    
    return [BestPostsLists predicateWithUrls:urls];
    }


 + (NSString*) predicateWithUrls: (NSArray*)urls
 {
 NSMutableString* postsPredicate;
 
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
