//
//  ALViewController.m
//  Mph
//
//  Created by えいる on 2014/08/24.
//  Copyright (c) 2014年 Tomohiko Himura. All rights reserved.
//

#import "ALViewController.h"
#import "AZSocketIO/AZSocketIO.h"
#import <CoreMotion/CoreMotion.h>

@interface ALViewController ()
{
    AZSocketIO* _socket;
    CMMotionManager *_motionManager;
    BOOL _socketActive;
}

@end

#define API_URL @"http://api.m-ph.org:3000"

@implementation ALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _socketActive = false;
    _motionManager = [[CMMotionManager alloc] init];
    
    if (_motionManager.accelerometerAvailable) {
        _motionManager.accelerometerUpdateInterval = 0.1;
        
        CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error) {
            if (!_socketActive) { return; }
            double timestamp = data.timestamp;
            double x = data.acceleration.x;
            double y = data.acceleration.y;
            double z = data.acceleration.z;
            double mag = 10 * ( sqrt(x*x + y*y + z*z) - 1 );
            NSLog(@"%@",[NSNumber numberWithDouble:mag]);
            [_socket emit:@"send swing" args:[NSNumber numberWithDouble:mag] error:nil];
        };
        
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    }
    _socket = [[AZSocketIO alloc] initWithHost:@"api.m-ph.org" andPort:@"3000" secure:NO];
    [_socket connectWithSuccess:^{
        NSLog(@"connect");
        _socketActive = true;
    } andFailure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    ALViewController __weak *this = self;
    [_socket setEventReceivedBlock:^(NSString *eventName, id data) {
        if ([@"push swing" isEqual:eventName]) {
            [this swing:data];
        } else if ([@"push msg" isEqual:eventName]) {
            [this message:data];
        }
    }];
}

- (void)swing:(NSArray*)mags
{
    _swingLabel.text = [NSString stringWithFormat:@"%@", mags[0]];
}

- (void)message:(id)msg
{
    NSString* message = msg[0];
    UILabel* label = [UILabel new];
    label.text = message;
    NSInteger x = rand() % 300;
    NSInteger y = rand() % 200 + 100;
    NSInteger size = rand() % 20+10;
    label.font = [UIFont systemFontOfSize:size];
    label.frame = CGRectMake(x, y, 100, size);
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapMessage:(id)sender {
    NSError* error = nil;
    NSLog(@"%@",_messageField.text);
    [_socket emit:@"send msg" args:@[_messageField.text] error:&error];
    if (error){
        NSLog(@"%@",error);
    } else {
        _messageField.text = @"";
    }
}
@end
