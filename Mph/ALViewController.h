//
//  ALViewController.h
//  Mph
//
//  Created by えいる on 2014/08/24.
//  Copyright (c) 2014年 Tomohiko Himura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *swingLabel;
@property (weak, nonatomic) IBOutlet UITextField *messageField;

- (IBAction)tapMessage:(id)sender;

@end
