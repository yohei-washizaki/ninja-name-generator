//
//  GUPViewController.m
//  ninjanamegenerator
//
//  Created by Washizaki Yohei on 2014/02/11.
//  Copyright (c) 2014年 Washi. All rights reserved.
//

#import "GUPViewController.h"
#import <Social/Social.h>

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
    NSLog(@"Button is touched up inside.");
    NSDictionary * familyName  = [self randomNameFromDB:self.familyNameDB];
    NSDictionary * popularName = [self randomNameFromDB:self.popularNameDB];
    NSDictionary * firstName   = [self randomNameFromDB:self.firstNameDB];
    
    self.familyName.text  = [familyName objectForKey:@"English"];
    self.popularName.text = [popularName objectForKey:@"English"];
    self.firstName.text   = [firstName objectForKey:@"English"];
    
    NSString * kanjiName  = [NSString stringWithFormat:@"%@ %@ %@",
                             [familyName objectForKey:@"Japanese"],
                             [popularName objectForKey:@"Japanese"],
                             [firstName objectForKey:@"Japanese"]];

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
    NSString * pathToFamilyNameDB = [mainBundle pathForResource:@"FamilyName" ofType:@"plist"];
    self.familyNameDB = [NSArray arrayWithContentsOfFile:pathToFamilyNameDB];
    NSLog(@"%@", self.familyNameDB);
    
    // Popular name
    NSString * pathToPopularNameDB = [mainBundle pathForResource:@"PopularName" ofType:@"plist"];
    self.popularNameDB = [NSArray arrayWithContentsOfFile:pathToPopularNameDB];
    NSLog(@"%@", self.popularNameDB);
    
    // First name(Secret Name)
    NSString * pathToFirstNameDB = [mainBundle pathForResource:@"FirstName" ofType:@"plist"];
    self.firstNameDB = [NSArray arrayWithContentsOfFile:pathToFirstNameDB];
    NSLog(@"%@", self.firstNameDB);
}

-(NSDictionary*)randomNameFromDB:(NSArray *)DB
{
    uint32_t index = arc4random() % DB.count;
    NSDictionary * retvalue = [DB objectAtIndex:index];
    return retvalue;
}

@end
