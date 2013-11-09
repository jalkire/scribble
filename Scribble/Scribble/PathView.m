//
//  PathView.m
//  Scribble
//
//  Created by Nathan DeFreest on 11/9/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "PathView.h"
@interface PathView ()
@property UIBezierPath *path;
@property NSArray *oldpaths;
@end

@implementation PathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) beginPath: (CGPoint) startPoint;
{
    self.path = [[UIBezierPath alloc] init];
    [self.path moveToPoint:startPoint];
    
}
- (void) addPath: (CGPoint) point;
{
    [self.path addLineToPoint:point];
    [self setNeedsDisplay];

}
- (void) endPoint: (CGPoint) finalPoint;
{
    [self.path addLineToPoint:finalPoint];
    [self setNeedsDisplay];
    
    if (!self.oldpaths)
        self.oldpaths = [[NSArray alloc] init];
    
    self.oldpaths = [self.oldpaths arrayByAddingObject:self.path];
        
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIBezierPath *path in self.oldpaths)
    {
        CGContextSetLineWidth(context, 4);
        [[UIColor blackColor] setStroke];
        
        CGContextBeginPath(context);
        CGContextAddPath(context, path.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
    }

    CGContextSetLineWidth(context, 4);
    [[UIColor blackColor] setStroke];
    
    CGContextBeginPath(context);
    CGContextAddPath(context,self.path.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
    
    
}


@end
