//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#include "CompactBatteryAvocadoRootListController.h"

@implementation CompactBatteryAvocadoRootListController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0,0,self.table.bounds.size.width,170);
    CGRect Imageframe = CGRectMake(0,10,self.table.bounds.size.width,80);
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [UIColor colorWithRed: 0.52 green: 0.69 blue: 0.25 alpha: 1.00];
    
    
    UIImage *headerImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CompactBatteryAvocadoPrefs.bundle"] pathForResource:@"CompactBatteryAvocado512" ofType:@"png"]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:Imageframe];
    [imageView setImage:headerImage];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [headerView addSubview:imageView];
    
    CGRect labelFrame = CGRectMake(0,imageView.frame.origin.y + 90 ,self.table.bounds.size.width,80);
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [headerLabel setText:@"CompactBatteryAvocado"];
    [headerLabel setFont:font];
    [headerLabel setTextColor:[UIColor blackColor]];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [headerLabel setContentMode:UIViewContentModeScaleAspectFit];
    [headerLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [headerView addSubview:headerLabel];
    
    self.table.tableHeaderView = headerView;
    
    self.respringBtn = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(_reallyRespring)];
    self.navigationItem.rightBarButtonItem = self.respringBtn;
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        NSMutableArray *rootSpecifiers = [[NSMutableArray alloc] init];
        
        //Tweak
        PSSpecifier *tweakEnabledGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Tweak" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [tweakEnabledGroupSpec setProperty:@"No respring required for changes made." forKey:@"footerText"];
        [rootSpecifiers addObject:tweakEnabledGroupSpec];
        
        PSSpecifier *tweakEnabledSpec = [PSSpecifier preferenceSpecifierNamed:@"Mash Avocado" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
        [tweakEnabledSpec setProperty:@"Mash Avocado" forKey:@"label"];
        [tweakEnabledSpec setProperty:@"enabled" forKey:@"key"];
        [tweakEnabledSpec setProperty:@YES forKey:@"default"];
        [tweakEnabledSpec setProperty:COMPACT_BATTERY_AVOCADO_IDENTIFIER forKey:@"defaults"];
        [tweakEnabledSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:tweakEnabledSpec];
        
        //Avocado
        PSSpecifier *avocadoGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Avocado" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [avocadoGroupSpec setProperty:@"" forKey:@"footerText"];
        [rootSpecifiers addObject:avocadoGroupSpec];
        
        //hide dummy rings
        PSSpecifier *hideDummyRingsSpec = [PSSpecifier preferenceSpecifierNamed:@"Hide Dummy Rings" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
        [hideDummyRingsSpec setProperty:@"Hide Dummy Rings" forKey:@"label"];
        [hideDummyRingsSpec setProperty:@"hideDummyRings" forKey:@"key"];
        [hideDummyRingsSpec setProperty:@YES forKey:@"default"];
        [hideDummyRingsSpec setProperty:COMPACT_BATTERY_AVOCADO_IDENTIFIER forKey:@"defaults"];
        [hideDummyRingsSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:hideDummyRingsSpec];
        
        //vertical style
        PSSpecifier *verticalStyleGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [verticalStyleGroupSpec setProperty:@"Vertical style for battery percentage." forKey:@"footerText"];
        [rootSpecifiers addObject:verticalStyleGroupSpec];
        
        PSSpecifier *verticalStyleSpec = [PSSpecifier preferenceSpecifierNamed:@"Vertical Style" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSegmentCell edit:nil];
        [verticalStyleSpec setValues:@[@4, @5] titles:@[@"Top", @"Bottom"]];
        [verticalStyleSpec setProperty:@4 forKey:@"default"];
        [verticalStyleSpec setProperty:@"verticalStyle" forKey:@"key"];
        [verticalStyleSpec setProperty:COMPACT_BATTERY_AVOCADO_IDENTIFIER forKey:@"defaults"];
        [verticalStyleSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:verticalStyleSpec];
        
        //horizontal style
        PSSpecifier *horizontalStyleGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [horizontalStyleGroupSpec setProperty:@"Horizontal style for battery percentage." forKey:@"footerText"];
        [rootSpecifiers addObject:horizontalStyleGroupSpec];
        
        PSSpecifier *horizontalStyleSpec = [PSSpecifier preferenceSpecifierNamed:@"Horizontal Style" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSegmentCell edit:nil];
        [horizontalStyleSpec setValues:@[@1, @2, @3] titles:@[@"Left", @"Center", @"Right"]];
        [horizontalStyleSpec setProperty:@2 forKey:@"default"];
        [horizontalStyleSpec setProperty:@"horizontalStyle" forKey:@"key"];
        [horizontalStyleSpec setProperty:COMPACT_BATTERY_AVOCADO_IDENTIFIER forKey:@"defaults"];
        [horizontalStyleSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:horizontalStyleSpec];
        
        //blank
        PSSpecifier *blankSpecGroup = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rootSpecifiers addObject:blankSpecGroup];
        
        //Support Dev
        PSSpecifier *supportDevGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Development" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rootSpecifiers addObject:supportDevGroupSpec];
        
        PSSpecifier *supportDevSpec = [PSSpecifier preferenceSpecifierNamed:@"Support Development" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
        [supportDevSpec setProperty:@"Support Development" forKey:@"label"];
        [supportDevSpec setButtonAction:@selector(donation)];
        [supportDevSpec setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/CompactBatteryAvocadoPrefs.bundle/PayPal.png"] forKey:@"iconImage"];
        [rootSpecifiers addObject:supportDevSpec];
        
        
        //Contact
        PSSpecifier *contactGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Contact" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rootSpecifiers addObject:contactGroupSpec];
        
        //Twitter
        PSSpecifier *twitterSpec = [PSSpecifier preferenceSpecifierNamed:@"Twitter" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
        [twitterSpec setProperty:@"Twitter" forKey:@"label"];
        [twitterSpec setButtonAction:@selector(twitter)];
        [twitterSpec setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/CompactBatteryAvocadoPrefs.bundle/Twitter.png"] forKey:@"iconImage"];
        [rootSpecifiers addObject:twitterSpec];
        
        //Reddit
        PSSpecifier *redditSpec = [PSSpecifier preferenceSpecifierNamed:@"Reddit" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
        [redditSpec setProperty:@"Twitter" forKey:@"label"];
        [redditSpec setButtonAction:@selector(reddit)];
        [redditSpec setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/CompactBatteryAvocadoPrefs.bundle/Reddit.png"] forKey:@"iconImage"];
        [rootSpecifiers addObject:redditSpec];
        
        //udevs
        PSSpecifier *createdByGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [createdByGroupSpec setProperty:@"Created by udevs" forKey:@"footerText"];
        [createdByGroupSpec setProperty:@1 forKey:@"footerAlignment"];
        [rootSpecifiers addObject:createdByGroupSpec];
        
        _specifiers = rootSpecifiers;
    }
    
    return _specifiers;
}

- (void)donation {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/udevs"] options:@{} completionHandler:nil];
}

- (void)twitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/udevs9"] options:@{} completionHandler:nil];
}

- (void)reddit {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.reddit.com/user/h4roldj"] options:@{} completionHandler:nil];
}

-(void)_reallyRespring{
    NSURL *relaunchURL = [NSURL URLWithString:@"prefs:root=CompactBatteryAvocado"];
    SBSRelaunchAction *restartAction = [NSClassFromString(@"SBSRelaunchAction") actionWithReason:@"RestartRenderServer" options:4 targetURL:relaunchURL];
    [[NSClassFromString(@"FBSSystemService") sharedService] sendActions:[NSSet setWithObject:restartAction] withResult:nil];
}

@end
