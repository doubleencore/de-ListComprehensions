//
//  NSArray+DEListComprehension.h
//  ComprehensionTestbed
//
//  Created by Carl Veazey on 10/5/12.
//  Copyright (c) 2012 Double Encore, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^DEListComprehensionOutputBlock) (id x, NSUInteger idx);
typedef BOOL (^DEListComprehensionPredicateBlock) (id x, NSUInteger idx);

typedef id (^DEListComprehensionMultipleInputOutputBlock) (NSArray *inputs);
typedef BOOL (^DEListComprehensionMultipleInputPredicateBlock) (NSArray *inputs);

@interface NSArray (DEListComprehension)

- (NSArray *)deComprehensionWithOutput:(DEListComprehensionOutputBlock)outputBlock
                             predicate:(DEListComprehensionPredicateBlock)predicateOrNil;


@end

//  Equivalent to calling deComprehensionWithOutput:predicate: on list
NSArray *singleListComprehension(NSArray *list,
                                 DEListComprehensionOutputBlock outputBlock,
                                 DEListComprehensionPredicateBlock predicateBlock);

//  lists should contain only `NSArray` instances.
//  iterates the elements of lists in nested order, with depth of nesting corresponding to increasing array index.
//  
NSArray *multiListNestedComprehension(NSArray *lists,
                                      DEListComprehensionMultipleInputOutputBlock outputBlock,
                                      DEListComprehensionMultipleInputPredicateBlock predicateBlock);

//  lists should contain only `NSArray` instances.
NSArray *multiListParallelComprehension(NSArray *lists,
                                        DEListComprehensionMultipleInputOutputBlock outputBlock,
                                        DEListComprehensionMultipleInputPredicateBlock predicateBlock);