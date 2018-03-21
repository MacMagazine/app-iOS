#import "MMMFeaturedPostTableViewCell.h"
#import "HexColor.h"

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
	self.headlineLabel.highlightedTextColor = [UIColor blackColor];
	self.subheadlineLabel.textColor = [UIColor grayColor];
	self.subheadlineLabel.highlightedTextColor = [UIColor blackColor];

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
		self.contentView.backgroundColor = [UIColor colorWithHexString:@"#181818"];
		self.headlineLabel.textColor = [UIColor whiteColor];
		self.subheadlineLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
	}

	UIFontDescriptor *headlineFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
	CGFloat pointSize = headlineFont.pointSize;
	self.headlineLabel.font = [UIFont fontWithDescriptor:headlineFont size:pointSize];
	
	UIFontDescriptor *subheadlineFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline];
	CGFloat subpointSize = subheadlineFont.pointSize;
	self.subheadlineLabel.font = [UIFont fontWithDescriptor:subheadlineFont size:subpointSize];
	
	NSString *fontSize = [[NSUserDefaults standardUserDefaults] stringForKey:@"font-size-settings"];
	if (![fontSize isEqualToString:@""]) {
		UIFontDescriptor *headlineFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
		CGFloat pointSize = headlineFont.pointSize;
		self.headlineLabel.font = [UIFont fontWithDescriptor:headlineFont size:pointSize * ([fontSize isEqualToString:@"fontemaior"] ? 1.1 : 0.9 )];
		
		UIFontDescriptor *subheadlineFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline];
		CGFloat subpointSize = subheadlineFont.pointSize;
		self.subheadlineLabel.font = [UIFont fontWithDescriptor:subheadlineFont size:subpointSize * ([fontSize isEqualToString:@"fontemaior"] ? 1.1 : 0.9 )];
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
