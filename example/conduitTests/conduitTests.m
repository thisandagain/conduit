//
//  conduitTests.m
//  conduitTests
//
//  Created by Andrew Sliwinski on 6/17/12.
//  Copyright (c) 2012 DIY, Co. All rights reserved.
//

#import "conduitTests.h"

@implementation conduitTests

@synthesize conduit;
@synthesize bridge;

#pragma mark - Init

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [conduit release]; conduit = nil;
    [bridge release]; bridge = nil;
    
    [super tearDown];
}

#pragma mark - Suite

- (void)testBridgeInstance
{    
    STAssertNil(nil, nil);
}

@end