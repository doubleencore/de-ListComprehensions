//
//  ComprehensionTestbedTests.m
//  ComprehensionTestbedTests
//
//  Created by Carl Veazey on 10/5/12.
//  Copyright (c) 2012 Double Encore, Inc. All rights reserved.
//

#import "DEListComprehensionTests.h"
#import "DEListComprehension.h"

@implementation DEListComprehensionTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}


- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void)testIdentityComprehension
{
    DEListComprehensionOutputBlock outputBlock = ^id (id x, NSUInteger idx) {
        return x;
    };
    
    NSArray *input = @[@1, @2, @3, @4, @5];
    NSArray *output = [input deComprehensionWithOutput:outputBlock
                                           predicate:nil];
    
    STAssertEqualObjects(output, input, nil);
    STAssertFalse((output == input), @"The comprehension should in all cases generate a new list");
}


- (void)testSimpleAddition
{
    DEListComprehensionOutputBlock outputBlock = ^id (NSNumber *input, NSUInteger idx) {
        return [NSNumber numberWithInt:([input intValue] + 1)];
    };
    
    NSArray *input = @[@1, @2, @3];
    NSArray *expectedOutput = @[@2, @3, @4];
    NSArray *actualOutput = [input deComprehensionWithOutput:outputBlock
                                                 predicate:nil];
    STAssertEqualObjects(actualOutput, expectedOutput, nil);
}


- (void)testSimpleAdditionWithPredicate
{
    DEListComprehensionOutputBlock outputBlock = ^id (NSNumber *input, NSUInteger idx) {
        return [NSNumber numberWithInt:([input intValue] + 1)];
    };
    
    DEListComprehensionPredicateBlock predicateBlock = ^BOOL (NSNumber *input, NSUInteger index) {
        return ([input intValue] > 2);
    };
    
    NSArray *input = @[@1, @2, @3];
    NSArray *expectedOutput = @[@4];
    NSArray *actualOutput = [input deComprehensionWithOutput:outputBlock
                                                 predicate:predicateBlock];
    STAssertEqualObjects(actualOutput, expectedOutput, nil);
}


- (void)testMultiplyByIndex
{
    DEListComprehensionOutputBlock outputBlock = ^id (NSNumber *input, NSUInteger index) {
        NSInteger value = [input integerValue];
        return @((value * index));
    };
    
    NSArray *input = @[@1, @2, @3];
    NSArray *expectedOutput = @[@0, @2, @6];
    NSArray *actualOutput = [input deComprehensionWithOutput:outputBlock
                                                        predicate:nil];
    STAssertEqualObjects(actualOutput, expectedOutput, nil);
}


- (void)testEvenIndexIdentity
{
    DEListComprehensionOutputBlock outputBlock = ^id (id input, NSUInteger index) {
        return input;
    };
    
    DEListComprehensionPredicateBlock predicateBlock = ^BOOL (id input, NSUInteger index) {
        return ((index % 2) == 0);
    };
    
    NSArray *input = @[@1, @2, @3, @4, @5, @6, @7];
    NSArray *expectedOutput = @[@1, @3, @5, @7];
    NSArray *actualOutput = [input deComprehensionWithOutput:outputBlock
                                                        predicate:predicateBlock];
    STAssertEqualObjects(actualOutput, expectedOutput, nil);
}


- (void)testFunctionWithIndentity
{
    DEListComprehensionOutputBlock outputBlock = ^id (id input, NSUInteger idx) {
        return input;
    };
    
    NSArray *input = @[@1, @2, @3];
    NSArray *expectedOutput = @[@1, @2, @3];
    NSArray *actualOutput = singleListComprehension(input, outputBlock, nil);
    STAssertEqualObjects(actualOutput, expectedOutput, nil);
    STAssertFalse((expectedOutput == actualOutput), nil);
}

- (void)testFunctionWithPredicate
{
    DEListComprehensionOutputBlock outputBlock = ^id (id input, NSUInteger idx) {
        return input;
    };
    
    DEListComprehensionPredicateBlock predicateBlock = ^BOOL (NSNumber *input, NSUInteger idx) {
        return (([input intValue])  % 2 == 0);
    };
    
    NSArray *input = @[@1, @2, @3, @4];
    NSArray *expectedOutput = @[@2, @4];
    NSArray *actualOutput = singleListComprehension(input, outputBlock, predicateBlock);
    STAssertEqualObjects(actualOutput, expectedOutput, nil);
}


- (void)testFunctionMultiplyByIndex
{
    DEListComprehensionOutputBlock outputBlock = ^id (NSNumber *input, NSUInteger index) {
        return @([input intValue] * index);
    };

    NSArray *input = @[@1, @2, @3];
    NSArray *expectedOutput = @[@0, @2, @6];
    NSArray *acutalOutput = singleListComprehension(input, outputBlock, nil);
    STAssertEqualObjects(acutalOutput, expectedOutput, nil);
}


- (void)testFunctionEvenIndexes
{
    DEListComprehensionOutputBlock outputBlock = ^id (id obj, NSUInteger index) {
        return obj;
    };
    
    DEListComprehensionPredicateBlock predicateBlock = ^BOOL (id obj, NSUInteger index) {
        return ((index % 2) == 0);
    };

    NSArray *input = @[@1, @2, @3, @4, @5, @6, @7];
    NSArray *expectedOutput = @[@1, @3, @5, @7];
    NSArray *actualOutput = singleListComprehension(input, outputBlock, predicateBlock);
    STAssertEqualObjects(actualOutput, expectedOutput, nil);
}


- (void)testNestedMultiplication
{
    DEListComprehensionMultipleInputOutputBlock outputBlock = ^id (NSArray *inputs) {
        __block int result = 1;
        [inputs enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
            result = result * [obj intValue];
        }];
        return @(result);
    };
    
    NSArray *input =   @[
                            @[@1, @2],
                            @[@2, @3],
                            @[@3, @4]
                        ];
    NSArray *expectedOutput = @[@6, @8, @9, @12, @12, @16, @18, @24];
    NSArray *actualOutput = multiListNestedComprehension(input, outputBlock, nil);
    STAssertEqualObjects(actualOutput, expectedOutput, nil);
}


extern NSArray *buildArguments(NSArray *prefix, NSArray *lists);

- (void)testBuildArgumentsTwoLists
{
    NSArray *input = @[
                        @[@1, @2],
                        @[@2, @3]
    ];
    NSArray *expectedArguments = @[
                                    @[@1, @2],
                                    @[@1, @3],
                                    @[@2, @2],
                                    @[@2, @3]
    ];
    NSArray *actualArguments = buildArguments(nil, input);
    STAssertEqualObjects(actualArguments, expectedArguments, @"expected %@ but got %@",expectedArguments, actualArguments);
}


- (void)testBuildARgumentsThreeLists
{
    NSArray *input = @[
                        @[@1, @2],
                        @[@2, @3],
                        @[@3, @4]
    ];
    
    NSArray *expectedArguments = @[
                        @[@1, @2, @3],
                        @[@1, @2, @4],
                        @[@1, @3, @3],
                        @[@1, @3, @4],
                        @[@2, @2, @3],
                        @[@2, @2, @4],
                        @[@2, @3, @3],
                        @[@2, @3, @4]
    ];
    
    NSArray *actualArguments = buildArguments(nil, input);
    STAssertEqualObjects(actualArguments, expectedArguments, nil);
}


- (void)testBuildArgumentsTwoListsThreeWide
{
    NSArray *input = @[
                        @[@1, @2, @3],
                        @[@1, @2, @3]
    ];
    NSArray *expectedArguments = @[
                        @[@1, @1],
                        @[@1, @2],
                        @[@1, @3],
                        @[@2, @1],
                        @[@2, @2],
                        @[@2, @3],
                        @[@3, @1],
                        @[@3, @2],
                        @[@3, @3]
    ];
    NSArray *actualArguments = buildArguments(nil, input);
    STAssertEqualObjects(actualArguments, expectedArguments, nil);
}


- (void)testParallelAddition
{
    NSArray *input = @[
                        @[@1, @2, @3],
                        @[@1, @2, @3],
                        @[@1, @2, @3]
    ];
    
    DEListComprehensionMultipleInputOutputBlock outputBlock = ^id (NSArray *input) {
        int sum = 0;
        for (NSNumber *number in input) {
            sum += [number intValue];
        }
        return @(sum);
    };
    
    NSArray *expectedResults = @[@3, @6, @9];
    NSArray *actualResults = multiListParallelComprehension(input, outputBlock, nil);
    STAssertEqualObjects(actualResults, expectedResults, nil);
}

@end
