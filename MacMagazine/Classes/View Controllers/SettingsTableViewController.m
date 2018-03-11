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
#import "Customslider.h"
#import "HexColor.h"

@interface SettingsTableViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *pushForAll;
@property (nonatomic, weak) IBOutlet Customslider *fontSize;
@property (nonatomic, weak) IBOutlet UITableViewCell *sliderCell;
@property (nonatomic, weak) IBOutlet UISwitch *darkMode;

@end

static NSString * const MMMReloadWebViewsNotification = @"com.macmagazine.notification.webview.reload";
static NSString * const MMMReloadTableViewsNotification = @"com.macmagazine.notification.tableview.reload";

@implementation SettingsTableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	[_fontSize setContinuous:NO];

	[_fontSize setNoOfTicks: 2];
	[_fontSize setIsTickType: YES];
	[_sliderCell.contentView insertSubview:[_fontSize addTickMarksView] belowSubview:_fontSize];

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
	
	[_pushForAll setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"all_posts_pushes"]];
	[_darkMode setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]];
	[self setMode:[_darkMode isOn]];
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
			
			[self close:nil];
		}];
	}

}

#pragma mark - View Methods

- (IBAction)close:(id)sender{
	NSString *fonteSize = @"";
	if ([_fontSize value] == 0.) {
		fonteSize = @"fontemenor";
	}
	if ([_fontSize value] == 2.) {
		fonteSize = @"fontemaior";
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:fonteSize forKey:@"font-size-settings"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MMMReloadTableViewsNotification object:nil];
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		[[NSNotificationCenter defaultCenter] postNotificationName:MMMReloadWebViewsNotification object:nil];
	}

	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setPushPreferences:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:[(UISwitch *)sender isOn] forKey:@"all_posts_pushes"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)darkMode:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:[(UISwitch *)sender isOn] forKey:@"dark_mode"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[self setMode:[(UISwitch *)sender isOn]];
}

- (void)setMode:(BOOL)darkMode {
	if (darkMode) {
		self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
		self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
		self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
		self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
		UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
		self.tableView.backgroundColor = [UIColor blackColor];

	} else {
		self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
		self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#0097d4"];
		self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"#0097d4"];
		self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
		UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
		self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];

	}

}

@end
