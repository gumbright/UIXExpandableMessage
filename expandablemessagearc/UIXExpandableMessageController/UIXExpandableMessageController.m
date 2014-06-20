//
//  UIXExpandableMessageController.m
//  ExpandedMessage
//
//  Created by Guy Umbright on 6/4/14.
//  Copyright (c) 2014 Guy Umbright. All rights reserved.
//

#import "UIXExpandableMessageController.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

static CGFloat kCompactWidth = 300.0;
static CGFloat kShortMesssageSeparator = 20.0;
static CGFloat kExpandedEdgeInset = 100.0;

static UIView* gMessageView;
static UIXExpandableMessageController* sController = nil;

@class UIXExpandableMessageView;

@protocol UIXExpandableMessageViewInternalDelegate <NSObject>
- (CGSize) UIXExpandableMessageViewExpandedSize;
- (void) UIXExpandableMessageViewExpanded: (UIXExpandableMessageView*) view;

@optional
- (void) UIXExpandableMessageViewOkayPressed:(UIXExpandableMessageView*) view;
- (void) UIXExpandableMessageViewEmailPressed:(UIXExpandableMessageView*) view;

@end

@interface UIXExpandableMessageView : UIView

@property (nonatomic, assign) BOOL compact;

@property (nonatomic, strong) IBOutlet UINavigationBar* navBar;
@property (nonatomic, strong) IBOutlet UILabel* shortMessage;
@property (nonatomic, strong) IBOutlet UITextView* messageDetail;
@property (nonatomic, strong) IBOutlet UIToolbar* toolBar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* detailsButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* mailButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* okayButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* separator;
@property (nonatomic, strong) IBOutlet UIView* contentView;
@property (nonatomic, strong) IBOutlet UIView* detailContent;
@property (nonatomic, strong) IBOutlet UIView* separatorView;
@property (nonatomic, assign) NSObject<UIXExpandableMessageViewInternalDelegate>* delegate;

@property (nonatomic, strong) UIXExpandableMessageController* controller;
@end

@implementation UIXExpandableMessageView

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) commonInit
{
    self.compact = YES;
    gMessageView = self;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self commonInit];
    }
    return self;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) awakeFromNib
{
    [self commonInit];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) dealloc
{
#if !(USING_ARC)
    [super dealloc];
#endif
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) layoutSubviews
{
    [super layoutSubviews];
    if (self.compact)
    {
        [self layoutCompact];
    }
    else
    {
        [self layoutExpanded];
    }
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) layoutCompact
{
    CGRect r;
    NSString* s = self.shortMessage.text;
    CGSize sz = [s sizeWithFont:self.shortMessage.font constrainedToSize:CGSizeMake(kCompactWidth, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    

    CGSize expandedSize = [self.delegate UIXExpandableMessageViewExpandedSize /*:self*/];
    CGFloat maxHeight = expandedSize.height - ((kShortMesssageSeparator * 2) + self.navBar.bounds.size.height + self.toolBar.bounds.size.height);
    
    //set the short message position
    r = CGRectMake(0, kShortMesssageSeparator, kCompactWidth, (sz.height < maxHeight) ? sz.height : maxHeight);
    self.shortMessage.frame = r;
    
    //hide the detail
    r = self.detailContent.frame;
    r.size.height = 0;
    r.origin.y = self.shortMessage.bounds.size.height;
    self.detailContent.frame = r;
    
    //set the content view
    r = self.contentView.frame;
    r.size.height = self.shortMessage.bounds.size.height + (kShortMesssageSeparator * 2);
    self.contentView.frame = r;
    
    r = CGRectMake(0, 0, kCompactWidth, self.contentView.bounds.size.height + self.navBar.bounds.size.height + self.toolBar.bounds.size.height);
    self.frame = r;

    self.toolBar.items = @[self.okayButton,self.separator,self.detailsButton];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) layoutExpanded
{
    [self.delegate UIXExpandableMessageViewExpanded:self];
    
    NSString* s = self.shortMessage.text;
    CGSize sz = [s sizeWithFont:self.shortMessage.font constrainedToSize:CGSizeMake(self.superview.bounds.size.width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect r = CGRectMake(0, 0, self.bounds.size.width, ceil(sz.height) + 20);
    self.shortMessage.frame = r;

    r = CGRectMake(0, self.shortMessage.bounds.size.height, self.bounds.size.width, self.superview.bounds.size.height - (self.shortMessage.bounds.size.height + self.navBar.bounds.size.height + self.toolBar.bounds.size.height));
    self.detailContent.frame = r;
    
    r = self.messageDetail.bounds;
    r.size.height = self.detailContent.bounds.size.height - self.separatorView.bounds.size.height;
    self.messageDetail.bounds = r;
    
    if ([MFMailComposeViewController canSendMail])
    {
        self.toolBar.items = @[self.okayButton,self.separator,self.mailButton];
    }
    else
    {
        self.toolBar.items = @[self.okayButton,self.separator];
    }
    
    self.frame = self.superview.bounds;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (IBAction)detailsPressed:(id)sender
{
    self.compact = NO;
    [self setNeedsLayout];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (IBAction)emailPressed:(id)sender
{
    [self.delegate UIXExpandableMessageViewEmailPressed:self];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (IBAction) okayPressed:(id)sender
{
    [self.delegate UIXExpandableMessageViewOkayPressed:self];
}

@end
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

@interface UIXExpandableMessageController ()<UIXExpandableMessageViewInternalDelegate>

//metrics
@property (nonatomic, assign) CGSize compactSize;
@property (nonatomic, assign) CGSize compactShortMessageSize;
@property (nonatomic, assign) CGRect compactShortMessageRect;

@property (nonatomic, assign) CGSize expandedSize;
@property (nonatomic, assign) CGRect expandedShortMessageRect;
@property (nonatomic, assign) CGRect expandedDetailsRect;

@property (nonatomic, copy) NSString* messageShort;
@property (nonatomic, copy) NSString* messageDetail;
@property (nonatomic, copy) NSString* messageTitle;
@end

@implementation UIXExpandableMessageController 
/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
+ (UIXExpandableMessageController*) messageWithTitle:(NSString *)title shortMessage:(NSString *)message detail:(NSString*) detail
{
    UIXExpandableMessageController* controller = [[UIXExpandableMessageController alloc] initWithTitle:title shortMessage:message detail:detail];
    
#if !(USING_ARC)
    [controller autorelease];
#endif
    return controller;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
+ (UIXExpandableMessageController*) messageWithError:(NSError *)error additionalDetail:(NSString*) detail
{
    UIXExpandableMessageController* controller = [[UIXExpandableMessageController alloc] initWithError:error additionalDetail:detail];
#if !(USING_ARC)
    [controller autorelease];
#endif
    return controller;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
+ (UIView *)superViewContainer {
    
    //Choose the the top subview view of the topmost presented view controller
    UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentedViewController].view;
    
    //If not controller is presented then look for the topmost subview of the root view controller.
    if(!rootView) {
        rootView = [[[UIApplication sharedApplication] keyWindow] rootViewController].view;
    }
    
    return rootView;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (UIViewController*) superViewController
{
    UIViewController *controller = [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentedViewController];
    
    //If not controller is presented then look for the topmost subview of the root view controller.
    if(!controller) {
        controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    }
    
    return controller;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (id)initWithTitle:(NSString *)title shortMessage:(NSString *)message detail:(NSString*) detail 
{
    self = [super initWithNibName:@"UIXExpandableMessageController" bundle:nil];
    if (self)
    {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        self.messageShort = message;
        self.messageDetail = detail;
        self.messageTitle = title;
    }
    return self;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (id)initWithError:(NSError *)error additionalDetail:(NSString*) additionalDetail;
{
    NSString* detail = (additionalDetail)?[NSString stringWithFormat:@"%@\n\n%@",error,additionalDetail]:[NSString stringWithFormat:@"%@",error];
    return [self initWithTitle:@"An error occurred"
                  shortMessage:error.localizedDescription
                        detail:detail];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) dealloc
{
#if !(USING_ARC)
    [super dealloc];
#endif
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIXExpandableMessageView* v = (UIXExpandableMessageView*) self.view;
    v.delegate = self;
    v.navBar.topItem.title = self.messageTitle;
    v.shortMessage.text = self.messageShort;
    v.messageDetail.text = self.messageDetail;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) presentInController:(UIViewController*) controller animated:(BOOL) animated
{
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [controller presentViewController:self animated:animated completion:^{
        self.view.superview.bounds = self.view.bounds;
        CGPoint pt = [self.view convertPoint:self.presentingViewController.view.center fromView:self.view.superview];
        self.view.superview.center = pt;
    }];
    self.view.superview.autoresizesSubviews = YES;
    self.view.superview.layer.cornerRadius = 10;
    self.view.superview.clipsToBounds = YES;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) show
{
    [self presentInController: [self superViewController] animated:YES];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (CGSize) UIXExpandableMessageViewExpandedSize //: (UIXExpandableMessageView*) view
{
    CGSize parentSize = self.presentingViewController.view.bounds.size;
    CGRect expandedFrame = CGRectMake(0, 0, parentSize.width - (kExpandedEdgeInset * 2), parentSize.height - (kExpandedEdgeInset * 2));
    return expandedFrame.size;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) UIXExpandableMessageViewExpanded: (UIXExpandableMessageView*) view
{
    CGSize expandedSize = [self UIXExpandableMessageViewExpandedSize /*:view*/];
    CGRect expandedFrame = CGRectZero;
    expandedFrame.size = expandedSize;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.superview.autoresizesSubviews = YES;
        self.view.superview.bounds = expandedFrame;

        if ([self.expandableMessageDelegate respondsToSelector:@selector(messageDidExpand:)])
        {
            [self.expandableMessageDelegate messageDidExpand:self];
        }
    }];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGSize viewSize = [self UIXExpandableMessageViewExpandedSize];

    CGRect expandedFrame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.superview.autoresizesSubviews = YES;
        self.view.superview.bounds = expandedFrame;
        
    }];    
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) UIXExpandableMessageViewOkayPressed:(UIXExpandableMessageView*) view
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    if ([self.expandableMessageDelegate respondsToSelector:@selector(messageDidDismiss:)])
    {
        [self.expandableMessageDelegate messageDidDismiss:self];
    }
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) UIXExpandableMessageViewEmailPressed:(UIXExpandableMessageView*) view
{
    if ([self.expandableMessageDelegate respondsToSelector:@selector(messageDidSelectEmail:)])
    {
        [self.expandableMessageDelegate messageDidSelectEmail:self];
    }
    UIViewController* parent = self.presentingViewController;
    
    NSString* messageShort = self.messageShort;
    NSString* messageDetail = self.messageDetail;
    
    NSString* emailSubject = self.emailSubject;
    
#if !(USING_ARC)
    sController = [self retain];
#else
    sController = self;
#endif
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        MFMailComposeViewController* mail = [[MFMailComposeViewController alloc] init];
#if !(USING_ARC)
        [mail autorelease];
#endif
        [mail setSubject:emailSubject];
        if (self.emailRecipients)
        {
            [mail setToRecipients:self.emailRecipients];
        }
        
        NSString* body = [NSString stringWithFormat:@"<H3>%@</H3><br/><br/><pre>%@</pre>",messageShort,messageDetail];
        
        [mail setMessageBody:body isHTML:YES];
        mail.mailComposeDelegate = self;
        
        [parent presentViewController:mail animated:YES completion:^{}];
    }];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:^{
        if ([self.expandableMessageDelegate respondsToSelector:@selector(messageDidDismiss:)])
        {
            [self.expandableMessageDelegate messageDidDismiss:self];
        }
#if !(USING_ARC)
        [sController release];
#endif
        sController = nil;
    }];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void)viewDidLayoutSubviews{
    self.view.superview.autoresizesSubviews = NO;
    self.view.superview.bounds = self.view.bounds;
    [super viewDidLayoutSubviews];
}

@end
