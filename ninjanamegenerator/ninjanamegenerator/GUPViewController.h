//
//  GUPViewController.h
//  ninjanamegenerator
//
//  Created by Washizaki Yohei on 2014/02/11.
//  Copyright (c) 2014年 Washi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface GUPViewController : UIViewController
<ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField * familyName;
@property (weak, nonatomic) IBOutlet UITextField * popularName;
@property (weak, nonatomic) IBOutlet UITextField * firstName;
@property (weak, nonatomic) IBOutlet UITextField * kanjiName;
@property (weak, nonatomic) IBOutlet UIView * contentView;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;

- (IBAction)onGenerateButtonTouchedUp:(id)sender;
- (IBAction)onTweetButtonTouchedUp:(id)sender;
@end
