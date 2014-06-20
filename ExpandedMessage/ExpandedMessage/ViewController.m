//
//  ViewController.m
//  ExpandedMessage
//
//  Created by Guy Umbright on 6/4/14.
//  Copyright (c) 2014 Guy Umbright. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) buttonPressed:(id)sender
{
    NSError* error;
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"AppDelegate" withExtension:@"txt"];
    NSString* detail = [NSString stringWithContentsOfURL:url
                                                encoding:NSUTF8StringEncoding error:&error];
    
    UIXExpandableMessageController* message = [UIXExpandableMessageController messageWithTitle:@"My Title"
                                                                                       shortMessage:@"Something happened and you really want to know more about it"
                                                                                             detail:detail];
    message.emailSubject = @"Error detail from app";
    message.expandableMessageDelegate = self;
    [message show];
}

- (IBAction) errorPressed:(id)sender
{
    NSError* error = nil;
    
    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/donkey/weasel/bananapants" error:&error];
    UIXExpandableMessageController* message = [UIXExpandableMessageController messageWithError:error
                                                                                   additionalDetail:[NSString stringWithFormat:@"error occurred near %s:%d",__FILE__,__LINE__]];
    
    message.emailSubject = @"Error detail from app";
    message.emailRecipients = @[@"bob@here.com",@"mary@there.com"];
    message.expandableMessageDelegate = self;
    
    [message show];
}

- (void) messageDidDismiss:(UIXExpandableMessageController *)expandableMessageController
{
    NSLog(@"UIXExpandableMessageController was dismissed");
}

- (void) messageDidSelectEmail:(UIXExpandableMessageController *)expandableMessageController
{
    NSLog(@"UIXExpandableMessageController started email");
}

- (void) messageDidExpand:(UIXExpandableMessageController *)expandableMessageController
{
    NSLog(@"UIXExpandableMessageController expanded");
}
@end
