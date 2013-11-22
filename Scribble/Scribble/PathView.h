//
//  PathView.h
//  Scribble
//
//  Created by Nathan DeFreest on 11/9/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PathView : UIView

@property UIBezierPath *path;
@property NSArray *oldpaths;


- (void) beginPath: (CGPoint) startPoint;
- (void) addPath: (CGPoint) point;
- (void) endPoint: (CGPoint) finalPoint;

@property UIColor *penColor;

@end
