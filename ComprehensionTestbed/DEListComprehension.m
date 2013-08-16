//
//  NSArray+DEListComprehension.m
//  ComprehensionTestbed
//
//  Created by Carl Veazey on 10/5/12.
//  Copyright (c) 2012 Double Encore, Inc. All rights reserved.
//

#import "DEListComprehension.h"

#define emptyNilGuard(array) if (!array) return nil; if (array.count == 0) return @[];

@implementation NSArray (DEListComprehension)


- (NSArray *)deComprehensionWithOutput:(DEListComprehensionOutputBlock)outputBlock
                           predicate:(DEListComprehensionPredicateBlock)predicateBlock
{
    return singleListComprehension(self, outputBlock, predicateBlock);
}


@end

// Private function to build lists of inputs for the multi-list comprehensions
NSArray *buildArguments(NSArray *prefix, NSArray *lists);


// This does the basic case list comprehension.
NSArray *singleListComprehension(NSArray *list,
                                        DEListComprehensionOutputBlock outputBlock,
                                        DEListComprehensionPredicateBlock predicateBlock)
{
    // If empty, return @[], if nil, return nil
    emptyNilGuard(list);
    
    // Temporarily holds the output of the comprehension as it's in progress.
    NSMutableArray *mutableOutput = [NSMutableArray arrayWithCapacity:list.count];
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //  Check the truth value of predicateBlock 1st so we can
        //  short-circuit the evaluation; if there's no predicate
        //  it implies that it is the true predicate.
        if (!predicateBlock || predicateBlock(obj, idx)) {
            id transformed = outputBlock(obj, idx);
            [mutableOutput addObject:transformed];
        }
    }];
    return [mutableOutput copy];
}


NSArray *buildArguments(NSArray *prefix, NSArray *lists)
{
    /***********
     Buid an array of lists representing the inputs that we will feed iteratively to outputblock
     array build(prefix, lists)
         if !lists return prefix
         list = lists[0]
         newLists = lists - list
         aggregator = mutable array
         for obj in list
             newPrefix = prefix + obj
             aggregator add:build(newPrefix, newLists)
         return aggregator
     **********/
    
    NSArray *list = lists[0];
    
    NSMutableArray *mutableLists = [lists mutableCopy];
    [mutableLists removeObjectAtIndex:0];
    NSArray *newLists = [mutableLists copy];
    
    NSMutableArray *aggregator = [NSMutableArray array];
    
    for (id obj in list) {
        NSMutableArray *mutableNewPrefix = [prefix mutableCopy];
        if (mutableNewPrefix == nil) {
            mutableNewPrefix = [NSMutableArray array];
        }
        [mutableNewPrefix addObject:obj];
        NSArray *newPrefix = [mutableNewPrefix copy];
        //Rather than the purely recursive version, this look-ahead lets you avoid building a tree rather than a list
        if (newLists.count == 0) {
             [aggregator addObject:newPrefix];
        }
        else {
            [aggregator addObjectsFromArray:buildArguments(newPrefix, newLists)];
        }
    }
    
    return aggregator;
}


NSArray *multiListNestedComprehension(NSArray *lists,
                                      DEListComprehensionMultipleInputOutputBlock outputBlock,
                                      DEListComprehensionMultipleInputPredicateBlock predicateBlock)
{
    emptyNilGuard(lists);
    
    NSArray *allArguments = buildArguments(nil, lists);
    NSMutableArray *results = [NSMutableArray array];
    for (NSArray *arguments in allArguments) {
        if (!predicateBlock || predicateBlock(arguments)) {
            [results addObject:outputBlock(arguments)];
        }
    }
    return [results copy];
}


NSArray *multiListParallelComprehension(NSArray *lists,
                                        DEListComprehensionMultipleInputOutputBlock outputBlock,
                                        DEListComprehensionMultipleInputPredicateBlock predicateBlock)
{
    emptyNilGuard(lists);
    
    NSArray *master = lists[0];
    NSMutableArray *mutableResults = [NSMutableArray arrayWithCapacity:master.count];
    
    [master enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableArray *mutableArguments = [NSMutableArray arrayWithObject:obj];
        for (NSArray *list in lists) {
            if (list != master) {
                [mutableArguments addObject:list[idx]];
            }
        }
        NSArray *arguments = [mutableArguments copy];
        if (!predicateBlock || predicateBlock(arguments)) {
            [mutableResults addObject:outputBlock(arguments)];
        }
    }];
    
    return [mutableResults copy];
}

