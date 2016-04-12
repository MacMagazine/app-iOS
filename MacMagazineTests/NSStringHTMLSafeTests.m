//
//  NSStringHTMLSafeTests.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 4/10/16.
//  Copyright © 2016 made@sampa. All rights reserved.
//

#import <Expecta/Expecta.h>
#import <XCTest/XCTest.h>

#import "NSString+HTMLSafe.h"

@interface NSStringHTMLSafeTests : XCTestCase

@end

@implementation NSStringHTMLSafeTests

- (void)testRemovingHTMLTags {
    NSString *input = @"<p>O melhor pedaço da <b>Maçã</b>.</p>";
    NSString *output = @"O melhor pedaço da Maçã.";
    expect([input mmm_htmlSafe]).to.equal(output);
}

@end
