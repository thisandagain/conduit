//
//  DIYViewController.h
//  conduit
//
//  Created by Andrew Sliwinski on 6/17/12.
//  Copyright (c) 2012 DIY, Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIYConduit.h"

@interface DIYViewController : UIViewController <DIYConduitDelegate>

@property (nonatomic, retain) IBOutlet DIYConduit *conduit;
@property (nonatomic, retain) IBOutlet UIButton *objcToJsButton;

- (IBAction)sendMessage:(id)sender;

@end