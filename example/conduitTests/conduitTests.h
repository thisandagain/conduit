//
//  conduitTests.h
//  conduitTests
//
//  Created by Andrew Sliwinski on 6/17/12.
//  Copyright (c) 2012 DIY, Co. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "DIYConduit.h"
#import "DIYConduitBridge.h"

@interface conduitTests : SenTestCase
{
    
}

@property (nonatomic, retain) DIYConduit *conduit;
@property (nonatomic, retain) DIYConduitBridge *bridge;

@end