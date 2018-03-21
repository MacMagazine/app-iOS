#import "MMMPostTableViewCell.h"
#import "HexColor.h"

@interface MMMPostTableViewCell ()

@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *thumbnailTrailingSpaceConstraint;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *thumbnailWidthConstraint;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *headlineBottomSpaceConstraint;

@end

#pragma mark MMMPostTableViewCell

@implementation MMMPostTableViewCell

#pragma mark - Getters/Setters

- (BOOL)imageVisible {
    return self.thumbnailWidthConstant > 0;
}

- (void)setImageVisible:(BOOL)imageVisible {
    if (imageVisible) {
        self.thumbnailWidthConstraint.constant = self.thumbnailWidthConstant;
        self.thumbnailTrailingSpaceConstraint.constant = self.thumbnailTrailingConstant;
    } else {
        self.thumbnailWidthConstraint.constant = 0;
        self.thumbnailTrailingSpaceConstraint.constant = 0;
    }
}

- (void)setThumbnailTrailingConstant:(CGFloat)thumbnailTrailingConstant {
    _thumbnailWidthConstant = thumbnailTrailingConstant;
    self.thumbnailTrailingSpaceConstraint.constant = thumbnailTrailingConstant;
}

- (void)setThumbnailWidthConstant:(CGFloat)thumbnailWidthConstant {
    _thumbnailWidthConstant = thumbnailWidthConstant;
    self.thumbnailWidthConstraint.constant = thumbnailWidthConstant;
}

- (void)setHeadlineBottomSpaceConstant:(CGFloat)headlineBottomSpaceConstant {
    _headlineBottomSpaceConstant = headlineBottomSpaceConstant;
    self.headlineBottomSpaceConstraint.constant = headlineBottomSpaceConstant;
}

#pragma mark - Instance Methods

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _thumbnailTrailingConstant = self.thumbnailTrailingSpaceConstraint.constant;
    _thumbnailWidthConstant = self.thumbnailWidthConstraint.constant;
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
    textWidth -= self.thumbnailWidthConstant;
    textWidth -= self.thumbnailTrailingConstant;
    textWidth -= self.trailingSpaceConstraint.constant;
    textWidth -= self.leadingSpaceConstraint.constant;
    textWidth -= self.layoutMargins.left;
    textWidth -= self.layoutMargins.right;
    
    self.headlineLabel.preferredMaxLayoutWidth = textWidth;
    self.subheadlineLabel.preferredMaxLayoutWidth = self.headlineLabel.preferredMaxLayoutWidth;
    
    [super layoutIfNeeded];
}

@end
