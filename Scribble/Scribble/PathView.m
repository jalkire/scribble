//
//  PathView.m
//  Scribble
//
//  Created by Nathan DeFreest on 11/9/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "PathView.h"
@interface PathView ()
//@property UIBezierPath *path;
//@property NSArray *oldPaths;
//@property NSArray *pathColors;

@end

@implementation PathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //frame.size.height = 0.2;          DIDN'T WORK
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
    {
        self.oldpaths = [[NSArray alloc] init];
        self.pathColors = [[NSArray alloc] init];
    }
    
    self.oldpaths = [self.oldpaths arrayByAddingObject:self.path];
    self.pathColors = [self.pathColors arrayByAddingObject:self.penColor];
        
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSInteger index = 0;
    
    for (UIBezierPath *path in self.oldpaths)
    {
        CGContextSetLineWidth(context, 4);
        
        [[self.pathColors objectAtIndex:index] setStroke];
        
        CGContextBeginPath(context);
        CGContextAddPath(context, path.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
        
        index++;
    }

    CGContextSetLineWidth(context, 4);
    [self.penColor setStroke];
    
    CGContextBeginPath(context);
    CGContextAddPath(context,self.path.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
    
    
}


@end
