//
//  GUPViewController.m
//  ninjanamegenerator
//
//  Created by Washizaki Yohei on 2014/02/11.
//  Copyright (c) 2014年 Washi. All rights reserved.
//

#import "GUPViewController.h"
#import <Social/Social.h>

static NSString * LANG_JA        = @"Japanese";
static NSString * LANG_EN        = @"English";
static NSString * DB_FAMILYNAME  = @"FamilyName";
static NSString * DB_POPULARNAME = @"PopularName";
static NSString * DB_FIRSTNAME   = @"FirstName";
static NSString * DB_EXT         = @"plist";

@interface GUPViewController ()

-(void)initializeDB;
-(NSDictionary*)randomNameFromDB:(NSArray*)DB;

@property(strong, nonatomic) NSArray * familyNameDB;
@property(strong, nonatomic) NSArray * popularNameDB;
@property(strong, nonatomic) NSArray * firstNameDB;

- (void)layoutAnimated:(BOOL)animated;

@end

@implementation GUPViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self initializeDB];

    if([self respondsToSelector:@selector(onGenerateButtonTouchedUp:)])
    {
        [self performSelector:@selector(onGenerateButtonTouchedUp:) withObject:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layoutAnimated:NO];
}

- (void)viewDidLayoutSubviews
{
    [self layoutAnimated:[UIView areAnimationsEnabled]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onGenerateButtonTouchedUp:(id)sender
{
    NSDictionary * familyName  = [self randomNameFromDB:self.familyNameDB];
    NSDictionary * popularName = [self randomNameFromDB:self.popularNameDB];
    NSDictionary * firstName   = [self randomNameFromDB:self.firstNameDB];
    
    self.familyName.text  = [familyName objectForKey:LANG_EN];
    self.familyName.text  = [self.familyName.text uppercaseString];
    self.popularName.text = [popularName objectForKey:LANG_EN];
    self.firstName.text   = [firstName objectForKey:LANG_EN];
    
    NSString * kanjiName  = [NSString stringWithFormat:@"%@%@%@",
                             [familyName objectForKey:LANG_JA],
                             [popularName objectForKey:LANG_JA],
                             [firstName objectForKey:LANG_JA]];

    self.kanjiName.text   = kanjiName;
}

#pragma mark - Social
- (IBAction)onTweetButtonTouchedUp:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        NSString * format = NSLocalizedString(@"TWITTER_TEXT", @"Initial text for twitter.");
        NSString * text = [NSString stringWithFormat:format,
                           self.familyName.text,
                           self.popularName.text,
                           self.firstName.text];
        SLComposeViewController * composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [composeController setInitialText:text];
        composeController.completionHandler = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultDone)
            {
                NSLog(@"Post succeeded!");
            }
        };
        [self presentViewController:composeController animated:YES completion:nil];
    }
}

#pragma mark - iAd
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"Banner view is begining an ad action.");
    return YES;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self layoutAnimated:YES];
}

- (void)layoutAnimated:(BOOL)animated
{
    CGRect contentFrame = self.contentView.frame;
    CGRect bannerFrame  = self.bannerView.frame;
    
    if (self.bannerView.bannerLoaded)
    {
        contentFrame.size.height -= self.bannerView.frame.size.height;
        bannerFrame.origin.y      = self.view.frame.size.height - self.bannerView.frame.size.height;
    }
    else
    {
        bannerFrame.origin.y = self.view.frame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        self.contentView.frame = contentFrame;
        [self.contentView layoutIfNeeded];
        self.bannerView.frame = bannerFrame;
    }];
}

#pragma mark - For internal
- (void)initializeDB
{
    NSBundle * mainBundle = [NSBundle mainBundle];
    
    // Family name
    NSString * pathToFamilyNameDB = [mainBundle pathForResource:DB_FAMILYNAME ofType:DB_EXT];
    self.familyNameDB = [NSArray arrayWithContentsOfFile:pathToFamilyNameDB];
    
    // Popular name
    NSString * pathToPopularNameDB = [mainBundle pathForResource:DB_POPULARNAME ofType:DB_EXT];
    self.popularNameDB = [NSArray arrayWithContentsOfFile:pathToPopularNameDB];
    
    // First name(Secret Name)
    NSString * pathToFirstNameDB = [mainBundle pathForResource:DB_FIRSTNAME ofType:DB_EXT];
    self.firstNameDB = [NSArray arrayWithContentsOfFile:pathToFirstNameDB];
}

-(NSDictionary*)randomNameFromDB:(NSArray *)DB
{
    uint32_t index = arc4random() % DB.count;
    NSDictionary * retvalue = [DB objectAtIndex:index];
    return retvalue;
}

@end
