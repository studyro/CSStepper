//
//  CSCodeView.m
//  Code
//
//  Created by Zhang Studyro on 13-2-13.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSCodeView.h"
#import <CoreText/CoreText.h>

static inline NSDictionary *CSCodeDefaultAttributes()
{
    NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionary];
    UIFont *uiFont = [UIFont systemFontOfSize:13.0];
    CTFontRef font = CTFontCreateWithName((CFStringRef)uiFont.fontName, 14.0, NULL);
    [mutableAttributes setObject:(id)font forKey:(NSString *)kCTFontAttributeName];
    CFRelease(font);
    
    [mutableAttributes setObject:(id)[UIColor blackColor].CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    
    CGFloat lineHeight = uiFont.lineHeight * 0.8;
    // see http://stackoverflow.com/questions/3374591/ctframesettersuggestframesizewithconstraints-sometimes-returns-incorrect-size/3376983#3376983
    CGFloat leading = lineHeight- uiFont.ascender + uiFont.descender;
    
    CTParagraphStyleSetting paragraphSettings[3] = {
        {.spec = kCTParagraphStyleSpecifierLineBreakMode, .valueSize = sizeof(CTLineBreakMode), .value = kCTLineBreakByWordWrapping},
        {.spec = kCTParagraphStyleSpecifierMaximumLineHeight, .valueSize = sizeof(CGFloat), .value = (const void*)&lineHeight},
        {.spec  = kCTParagraphStyleSpecifierLineSpacing, .valueSize = sizeof(CGFloat), .value = (const void*)&leading}
    };
    CTParagraphStyleRef paragraphSyle = CTParagraphStyleCreate(paragraphSettings, 3);
    [mutableAttributes setObject:(id)paragraphSyle forKey:(NSString *)kCTParagraphStyleAttributeName];
    CFRelease(paragraphSyle);
    
    return [NSDictionary dictionaryWithDictionary:mutableAttributes];
}

@interface CSCodeView ()
{
    NSMutableAttributedString *_mutableAttributedString;
    CTFramesetterRef _frameSetter;
}
@end

@implementation CSCodeView

- (void)dealloc
{
    if (_frameSetter) CFRelease(_frameSetter);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)prepareForFrameSetterWithAttributedString:(NSAttributedString *)attrString
{
    if ([attrString isEqualToAttributedString:_mutableAttributedString]) return;
    if (_frameSetter) CFRelease(_frameSetter);
    
    if (_mutableAttributedString) [_mutableAttributedString release];
    _mutableAttributedString = [attrString mutableCopy];
    _frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_mutableAttributedString);
}

- (void)setText:(NSString *)text configureWithBlock:(void (^)(NSMutableAttributedString *))block
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:CSCodeDefaultAttributes()];
    
    if (block) block(attrString);
    
    [self prepareForFrameSetterWithAttributedString:attrString];
    [attrString release];
}

- (CGFloat)suggestedTextHeight
{
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(_frameSetter, CFRangeMake(0, [_mutableAttributedString length]), NULL, CGSizeMake(0, CGFLOAT_MAX), NULL);
    return size.height;
}

- (void)highlightTextInRange:(NSRange)range
{
    [self _addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:range];
}

- (void)_addAttribute:(NSString *)attribute value:(id)v range:(NSRange)r
{
    NSMutableAttributedString *attrString = [_mutableAttributedString mutableCopy];
    [attrString addAttribute:attribute value:v range:r];
    [self prepareForFrameSetterWithAttributedString:attrString];
    [attrString release];
}

- (void)drawRect:(CGRect)rect
{
    if (_frameSetter) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0f, -1.0f);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectInset(rect, 2.0, 2.0));
        CTFrameRef frame = CTFramesetterCreateFrame(_frameSetter, CFRangeMake(0, [_mutableAttributedString length]), path, NULL);
        CTFrameDraw(frame, context);
        CFRelease(frame);
    }
}

@end
