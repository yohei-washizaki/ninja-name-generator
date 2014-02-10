//
//  GUPViewController.h
//  ninjanamegenerator
//
//  Created by Washizaki Yohei on 2014/02/11.
//  Copyright (c) 2014年 Washi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GUPViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField * familyName;
@property (weak, nonatomic) IBOutlet UITextField * popularName;
@property (weak, nonatomic) IBOutlet UITextField * firstName;
@property (weak, nonatomic) IBOutlet UITextField * kanjiName;

- (IBAction)onButtonTouchedUp:(id)sender;
@end
