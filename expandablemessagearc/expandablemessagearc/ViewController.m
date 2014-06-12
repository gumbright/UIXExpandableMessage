//
//  ViewController.m
//  expandablemessagearc
//
//  Created by Guy Umbright on 6/12/14.
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
    
    UIXExpandableMessageController* message = [[UIXExpandableMessageController alloc] initWithTitle:@"My Title"
                                                                                       shortMessage:@"Something happened and you really want to know more about it"
                                                                                             detail:detail];
    
    message.emailSubject = @"Error detail from app";
    
    [message presentInController:self animated:YES];
}

@end
