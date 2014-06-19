//
//  UIXExpandableMessageController.h
//  ExpandedMessage
//
//  Created by Guy Umbright on 6/4/14.
//  Copyright (c) 2014 Guy Umbright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#define				USING_ARC			((__has_feature(objc_arc)))

@interface UIXExpandableMessageController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, copy) NSString* emailSubject;  //subject line value for email sent from UIXExpandableMessage

- (id)initWithTitle:(NSString *)title shortMessage:(NSString *)message detail:(NSString*) detail;
- (id)initWithError:(NSError *)error additionalDetail:(NSString*) additionalDetail;

//display the message
- (void) show;

@end
