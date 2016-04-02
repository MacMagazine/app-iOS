//
//  MMMMacintoshScene.m
//  MacMagazine
//
//  Created by Cesar Barscevicius on 12/13/15.
//  Copyright © 2015 made@sampa. All rights reserved.
//

#import "MMMMacintoshScene.h"

@interface MMMMacintoshScene ()

@property (nonatomic ,strong) NSArray *macintoshFrames;
@property (nonatomic ,strong) SKSpriteNode *macintosh;

@end

@implementation MMMMacintoshScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        
        //Setup the array to hold the hello frames
        NSMutableArray *macFrames = [NSMutableArray array];
        
        //Load the TextureAtlas for the mac
        SKTextureAtlas *helloAtlas = [SKTextureAtlas atlasNamed:@"hello"];
        
        //Load the animation frames from the TextureAtlas
        NSInteger numImages = helloAtlas.textureNames.count;
        for (int i = 1; i <= numImages; i++) {
            NSString *textureName = [NSString stringWithFormat:@"mac-%d", i];
            SKTexture *temp = [helloAtlas textureNamed:textureName];
            [macFrames addObject:temp];
        }
        self.macintoshFrames = macFrames;
        
        //Create sprite, setup position in middle of the screen, and add to Scene
        SKTexture *temp = self.macintoshFrames[0];
        self.macintosh = [SKSpriteNode spriteNodeWithTexture:temp];
        self.macintosh.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.macintosh.size = CGSizeMake(200, 200);
        [self addChild:self.macintosh];
        
        [self animateMac];
    }
    return self;
}

-(void)animateMac {
    [self.macintosh runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.macintoshFrames timePerFrame:0.037f resize:NO restore:YES]] withKey:@"hello"];
    
    return;
}

@end
