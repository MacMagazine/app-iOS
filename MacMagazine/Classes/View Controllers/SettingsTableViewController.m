//
//  SettingsTableViewController.m
//  MacMagazine
//
//  Created by Cassio Rossi on 04/03/18.
//  Copyright © 2018 made@sampa. All rights reserved.
//

@import WebKit;

#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>
#import <SDWebImage/SDImageCache.h>

#import "SettingsTableViewController.h"
#import "Customslider.h"
#import "HexColor.h"
#import "MMMPost.h"
#import "SUNCoreDataStore.h"

@interface SettingsTableViewController () <MFMailComposeViewControllerDelegate>

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

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[_sliderCell.contentView insertSubview:[_fontSize addTickMarksView] belowSubview:_fontSize];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
	UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
		// View color
		[header.contentView setBackgroundColor:[UIColor blackColor]];

		// Text Color
		[header.textLabel setTextColor:[UIColor whiteColor]];
	} else {
		// View color
		[header.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

		// Text Color
		[header.textLabel setTextColor:[UIColor darkGrayColor]];
	}
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
	UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
		// View color
		[footer.contentView setBackgroundColor:[UIColor blackColor]];

		// Text Color
		[footer.textLabel setTextColor:[UIColor whiteColor]];
	} else {
		// View color
		[footer.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

		// Text Color
		[footer.textLabel setTextColor:[UIColor darkGrayColor]];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - View Methods

- (IBAction)clean:(id)sender {
	// Delete all from CoreData
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"MMMPost"];
	NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
	
	NSError *deleteError = nil;
	NSPersistentStoreCoordinator *psc = [[SUNCoreDataStore defaultStore] persistentStoreCoordinator];
	[psc executeRequest:delete withContext:[[SUNCoreDataStore defaultStore] mainQueueContext] error:&deleteError];
	psc = nil; delete = nil; request = nil;

	[[SDImageCache sharedImageCache] clearDisk];
	
	NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
	NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
	
	[[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"lastSelection"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"clear_cache"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		[self close:nil];
	}];
}

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
		self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#181818"];
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
	
	[self tableViewMode:darkMode];

}

- (void)tableViewMode:(BOOL)darkmode {
	NSInteger sections = [self.tableView numberOfSections];
	for (NSInteger section = 0; section < sections; section++ ) {
		NSInteger rows = [self.tableView numberOfRowsInSection:section];
		for (NSInteger row = 0; row < rows; row++ ) {
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
			
			cell.contentView.backgroundColor = (darkmode ? [UIColor colorWithHexString:@"#181818"] : [UIColor whiteColor]);

			for (id object in cell.contentView.subviews) {
				if ([object isKindOfClass:[UILabel class]]) {
					UILabel *obj = (UILabel *)object;
					obj.textColor = (darkmode ? [UIColor whiteColor] : [UIColor blackColor]);
					obj = nil;
				}
				if ([object isKindOfClass:[UIButton class]]) {
					UIButton *obj = (UIButton *)object;
					[obj setTitleColor:(darkmode ? [UIColor whiteColor] : [UIColor blackColor]) forState:UIControlStateNormal];
					obj = nil;
				}
			}
		}
	}
	
	[self.tableView reloadData];
}

- (IBAction)reportProblem:(id)sender {
	if ([MFMailComposeViewController canSendMail]) {

		MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
		mailVC.mailComposeDelegate = self;

		[mailVC setSubject:@"Relato de problema na App MacMagazine"];
		[mailVC setToRecipients:@[@"contato@macmagazine.com.br"]];
		
		[self presentViewController:mailVC animated:YES completion:nil];
		
	} else {
		NSLog(@"This device cannot send email");
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

	[self dismissViewControllerAnimated:YES completion:NULL];

}

@end
