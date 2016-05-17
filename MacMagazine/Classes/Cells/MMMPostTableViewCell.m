#import "MMMPostTableViewCell.h"

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
