//
//  AppDelegate.m
//  ComprehensionTestbed
//
//  Created by Carl Veazey on 10/5/12.
//  Copyright (c) 2012 Double Encore, Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "DEListComprehension.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //Example 1 from blog post.
    /*
    NSArray *originals = @[ @1, @2, @3, @4, @5 ];
    NSArray *squares = [originals deComprehensionWithOutput:^id(NSNumber *x, NSUInteger index) {
                                                    return @([x integerValue] * [x integerValue]);
                                                }
                                                predicate:nil];
    NSLog(@"squares = %@", squares);
    */
    
    // Example 2 from blog post
    /*
    NSArray *originals = @[@1, @2, @3, @4, @5];
    NSArray *squares = [originals deComprehensionWithOutput:^id(id x, NSUInteger idx) {
        return @([x integerValue] * [x integerValue]);
    } predicate:^BOOL(id x, NSUInteger idx) {
        return [x integerValue] % 2 == 0;
    }];
    NSLog(@"squares = %@",squares);
    */
    // example 3
    NSArray *a = @[@1, @2, @3];
    NSArray *b = @[@1, @2, @3];
    NSArray *c = @[@3, @4, @5];
    NSArray *r = multiListParallelComprehension(@[a,b,c], ^id(NSArray *inputs) {
        NSInteger sum = 0;
        for (NSNumber *n in inputs) {
            sum += [n integerValue];
        }
        return @(sum);
    }, nil);
    NSLog(@"result = %@", r);
    
    NSArray *first = @[@1, @2, @3, @4];
    NSArray *second = @[@5, @6, @7, @8];
    NSArray *result = multiListNestedComprehension(@[first, second], ^id(NSArray *inputs) {
        NSInteger product = 1;
        for (NSNumber *n in inputs) {
            product = product * [n integerValue];
        }
        return @(product);
    }, nil);
    NSLog(@"result = %@", result);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
