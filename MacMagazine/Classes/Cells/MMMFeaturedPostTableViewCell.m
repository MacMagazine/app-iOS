#import "MMMFeaturedPostTableViewCell.h"

@interface MMMFeaturedPostTableViewCell ()

@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *headlineTopSpaceConstraint;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *headlineBottomSpaceConstraint;

@end

#pragma mark MMMFeaturedPostTableViewCell

@implementation MMMFeaturedPostTableViewCell

#pragma mark - Instance Methods

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _headlineTopSpaceConstant = self.headlineTopSpaceConstraint.constant;
    _headlineBottomSpaceConstant = self.headlineBottomSpaceConstraint.constant;
    
    self.thumbnailImageView.image = nil;
    self.headlineLabel.text = @"";
    self.subheadlineLabel.text = @"";
}

- (void)layoutIfNeeded {
	self.contentView.backgroundColor = [UIColor whiteColor];
	self.headlineLabel.textColor = [UIColor blackColor];
	self.subheadlineLabel.textColor = [UIColor grayColor];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
		self.contentView.backgroundColor = [UIColor darkGrayColor];
		self.headlineLabel.textColor = [UIColor whiteColor];
		self.subheadlineLabel.textColor = [UIColor whiteColor];
	}

	UIFont *headlineFont = self.headlineLabel.font;
	UIFont *newFontSize = [UIFont fontWithName:headlineFont.fontName size:17.];
	self.headlineLabel.font = newFontSize;
	
	UIFont *subheadlineFont = self.headlineLabel.font;
	newFontSize = [UIFont fontWithName:subheadlineFont.fontName size:14.];
	self.subheadlineLabel.font = newFontSize;
	
	newFontSize = nil; headlineFont = nil; subheadlineFont = nil;

	NSString *fontSize = [[NSUserDefaults standardUserDefaults] stringForKey:@"font-size-settings"];
	if (![fontSize isEqualToString:@""]) {
		UIFont *headlineFont = self.headlineLabel.font;
		CGFloat size = ([fontSize isEqualToString:@"fontemaior"] ? 19. : 15. );
		UIFont *newFontSize = [UIFont fontWithName:headlineFont.fontName size:size];
		self.headlineLabel.font = newFontSize;
		
		UIFont *subheadlineFont = self.headlineLabel.font;
		size = ([fontSize isEqualToString:@"fontemaior"] ? 16. : 12. );
		newFontSize = [UIFont fontWithName:subheadlineFont.fontName size:size];
		self.subheadlineLabel.font = newFontSize;
		
		newFontSize = nil; headlineFont = nil; subheadlineFont = nil;
	}
	fontSize = nil;

	CGFloat textWidth = self.layoutWidth;
    textWidth -= self.trailingSpaceConstraint.constant;
    textWidth -= self.leadingSpaceConstraint.constant;
    textWidth -= self.layoutMargins.left;
    textWidth -= self.layoutMargins.right;
    
    self.headlineLabel.preferredMaxLayoutWidth = textWidth;
    self.subheadlineLabel.preferredMaxLayoutWidth = self.headlineLabel.preferredMaxLayoutWidth;
    
    [super layoutIfNeeded];
}

@end
