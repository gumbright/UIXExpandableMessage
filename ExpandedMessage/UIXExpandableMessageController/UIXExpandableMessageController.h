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

@class UIXExpandableMessageController;

@protocol UIXExpandableMessageViewDelegate <NSObject>
@optional
- (void) messageDidDismiss:(UIXExpandableMessageController*) expandableMessageController;
- (void) messageDidExpand:(UIXExpandableMessageController*) expandableMessageController;
- (void) messageDidSelectEmail:(UIXExpandableMessageController*) expandableMessageController;

@end

@interface UIXExpandableMessageController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, copy) NSString* emailSubject;  //subject line value for email sent from UIXExpandableMessage
@property (nonatomic, copy) NSArray* emailRecipients; //array of email address to send the email to (the "To" receipents)

@property (nonatomic, assign) NSObject<UIXExpandableMessageViewDelegate>* expandableMessageDelegate;

+ (UIXExpandableMessageController*) messageWithTitle:(NSString *)title shortMessage:(NSString *)message detail:(NSString*) detail;
+ (UIXExpandableMessageController*) messageWithError:(NSError *)error additionalDetail:(NSString*) detail;

//display the message
- (void) show;

@end
