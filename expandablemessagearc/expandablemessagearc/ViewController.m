//
//  ViewController.m
//  expandablemessagearc
//
//  Created by Guy Umbright on 6/12/14.
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
                                                                                       shortMessage:@"Something happened and you really want to know more about it. Really. Its something that is of critical importance. You should pay attention to it. So lets me this one really long so that it pushes the limits of the length so that it can be verified that there is the upper height limit imposed that matches the expanded size of the view. So, increasingly, referring to this as a short message is a misnomer of the highest degree...if you can accept the premise that there are varying degrees of misnomers."
                                                                                             detail:detail];
    
    message.emailSubject = @"Error detail from app";
    message.expandableMessageDelegate = self;
    [message show];
}

- (IBAction) errorPressed:(id)sender
{
    NSError* error = nil;
    
    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/donkey/weasel/bananapants" error:&error];
    UIXExpandableMessageController* message = [UIXExpandableMessageController messageWithError:error additionalDetail:[NSString stringWithFormat:@"error occurred near %s:%d",__FILE__,__LINE__]];
    
    message.emailSubject = @"Error detail from app";
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
