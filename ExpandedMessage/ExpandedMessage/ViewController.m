//
//  ViewController.m
//  ExpandedMessage
//
//  Created by Guy Umbright on 6/4/14.
//  Copyright (c) 2014 Guy Umbright. All rights reserved.
//

#import "ViewController.h"
#import "UIXExpandableMessageController.h"

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
    
    UIXExpandableMessageController* message = [[[UIXExpandableMessageController alloc] initWithTitle:@"My Title"
                                                                                       shortMessage:@"Something happened and you really want to know more about it"
                                                                                             detail:detail] autorelease];
    message.emailSubject = @"Error detail from app";
    
    [message show];
}

- (IBAction) errorPressed:(id)sender
{
    NSError* error = nil;
    
    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/donkey/weasel/bananapants" error:&error];
    UIXExpandableMessageController* message = [[[UIXExpandableMessageController alloc] initWithError:error
                                                                                   additionalDetail:[NSString stringWithFormat:@"error occurred near %s:%d",__FILE__,__LINE__]] autorelease];
    
    message.emailSubject = @"Error detail from app";
    [message autorelease];
    
    [message show];
}

- (IBAction) showPressed:(id)sender
{
    NSError* error;
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"AppDelegate" withExtension:@"txt"];
    NSString* detail = [NSString stringWithContentsOfURL:url
                                                encoding:NSUTF8StringEncoding error:&error];
    
    UIXExpandableMessageController* message = [[[UIXExpandableMessageController alloc] initWithTitle:@"My Title"
                                                                                       shortMessage:@"Something happened and you really want to know more about it"
                                                                                             detail:detail] autorelease];
    
    message.emailSubject = @"Error detail from app";
    [message show];
}
@end
