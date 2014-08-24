//
//  ALViewController.m
//  Mph
//
//  Created by えいる on 2014/08/24.
//  Copyright (c) 2014年 Tomohiko Himura. All rights reserved.
//

#import "ALViewController.h"
#import "AZSocketIO/AZSocketIO.h"

@interface ALViewController ()
{
    AZSocketIO* _socket;
}

@end

#define API_URL @"http://api.m-ph.org:3000"

@implementation ALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _socket = [[AZSocketIO alloc] initWithHost:@"api.m-ph.org" andPort:@"3000" secure:NO];
    [_socket connectWithSuccess:^{
        NSLog(@"connect");
    } andFailure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    ALViewController __weak *this = self;
    [_socket setEventReceivedBlock:^(NSString *eventName, id data) {
        if ([@"push swing" isEqual:eventName]) {
            [this swing:data];
        }
    }];
}

- (void)swing:(NSArray*)mags
{
    _swingLabel.text = [NSString stringWithFormat:@"%@", mags[0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
