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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onGenerateButtonTouchedUp:(id)sender
{
    NSDictionary * familyName  = [self randomNameFromDB:self.familyNameDB];
    NSDictionary * popularName = [self randomNameFromDB:self.popularNameDB];
    NSDictionary * firstName   = [self randomNameFromDB:self.firstNameDB];
    
    self.familyName.text  = [familyName objectForKey:LANG_EN];
    self.popularName.text = [popularName objectForKey:LANG_EN];
    self.firstName.text   = [firstName objectForKey:LANG_EN];
    
    NSString * kanjiName  = [NSString stringWithFormat:@"%@%@%@",
                             [familyName objectForKey:LANG_JA],
                             [popularName objectForKey:LANG_JA],
                             [firstName objectForKey:LANG_JA]];

    self.kanjiName.text   = kanjiName;
}

- (IBAction)onTweetButtonTouchedUp:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        NSString * text = [NSString stringWithFormat:@"◆試験的な投稿◆ My Ninja Name is %@ %@ %@.",
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
