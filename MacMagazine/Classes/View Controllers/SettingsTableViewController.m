//
//  SettingsTableViewController.m
//  MacMagazine
//
//  Created by Cassio Rossi on 04/03/18.
//  Copyright © 2018 made@sampa. All rights reserved.
//

@import WebKit;

#import <SDWebImage/SDImageCache.h>

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *pushForAll;
@property (nonatomic, weak) IBOutlet UISlider *fontSize;
	
@end

static NSString * const MMMReloadWebViewsNotification = @"com.macmagazine.notification.webview.reload";

@implementation SettingsTableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	[_fontSize setContinuous:NO];

	// Read old settings
	NSString *fontSize = [[NSUserDefaults standardUserDefaults] stringForKey:@"font-size-settings"];
	if ([fontSize isEqualToString:@""]) {
		[_fontSize setValue:1];
	}
	if ([fontSize isEqualToString:@"fontemenor"]) {
		[_fontSize setValue:0];
	}
	if ([fontSize isEqualToString:@"fontemaior"]) {
		[_fontSize setValue:2];
	}
	fontSize = nil;
	
	[_pushForAll setOn:	[[NSUserDefaults standardUserDefaults] boolForKey:@"all_posts_pushes"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate
	
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if (indexPath.section == 0 && indexPath.row == 0) {
		// Clean Cache
		[[SDImageCache sharedImageCache] clearDisk];
		
		NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
		NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
		
		[[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
			[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"clear_cache"];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}];
	}

}

#pragma mark - View Methods

- (IBAction)close:(id)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setPushPreferences:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:[(UISwitch *)sender isOn] forKey:@"all_posts_pushes"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeFont:(id)sender {
	UISlider *slider = (UISlider *)sender;
	NSInteger value = 1;
	if ([slider value] > 1.5f) {
		value = 2;
	} else if ([slider value] < 0.5f) {
		value = 0;
	}
	[_fontSize setValue:value animated:YES];
	
	NSString *fonteSize = @"";
	if ([_fontSize value] == 0) {
		fonteSize = @"fontemenor";
	}
	if ([_fontSize value] == 2) {
		fonteSize = @"fontemaior";
	}

	[[NSUserDefaults standardUserDefaults] setObject:fonteSize forKey:@"font-size-settings"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		[[NSNotificationCenter defaultCenter] postNotificationName:MMMReloadWebViewsNotification object:nil];
	}

	fonteSize = nil;
}
	
@end
