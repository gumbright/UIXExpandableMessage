UIXExpandableMessageController
====================

A view controller for a message that can be expanded to show detail and allow mailing the detail

![UIXExpandableMessage GIF](UIXExpandableMessage.gif)

UIXExpandableMessageController supports iOS 6.1+ SDK, ARC and non-ARC, and handles rotation.  It is intended for use in iPad applications.

#Usage

UIXExpandableMessage is intended to be as simple to use as UIAlert.  There are two factory methods:

```objectivec
+ (UIXExpandableMessageController*) messageWithTitle:(NSString *)title shortMessage:(NSString *)message detail:(NSString*) detail;

+ (UIXExpandableMessageController*) messageWithError:(NSError *)error additionalDetail:(NSString*) detail;
```

`messageWithError` takes an NSError and uses `error.localizedDescription` as the short message and uses the standard description string as the detail message.

`messageWithTitle` allows for user specified message contents

Displaying the message is similar to UIAlert, using a `show` method:

```objectivec
- (void) show;
```


##Properties

```objectivec
@property (nonatomic, copy) NSString* emailSubject;  //subject line value for email sent from UIXExpandableMessage

@property (nonatomic, copy) NSArray* emailRecipients; //array of email address to send the email to (the "To" receipents)

@property (nonatomic, assign) NSObject<UIXExpandableMessageViewDelegate>* expandableMessageDelegate;
```

##Delegate

UIXExpandableMessageContoller does not allow for much interactivity, but a delegate is provided as a courtesy if some indication of what is being done with the message is desired.  All methods are optional:

```objectivec
- (void) messageDidDismiss:(UIXExpandableMessageController*) expandableMessageController;
- (void) messageDidExpand:(UIXExpandableMessageController*) expandableMessageController;
- (void) messageDidSelectEmail:(UIXExpandableMessageController*) expandableMessageController;
```
#Including UIXExpandableMessageContoller in your project

Just add the UIXExpandableMessageController folder to your project making sure all contents are included in your desired target (2 source files, 1 xib).

##Known issues
Scrolling in the detail view can be choppy, have not figured that one out yet.
