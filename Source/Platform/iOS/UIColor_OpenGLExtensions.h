//
//  UIColor_OpenGLExtensions.h
//  TouchOpenGL
//
//  Created by Jonathan Wight on 02/05/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OpenGLTypes.h"

@interface UIColor (UIColor_OpenGLExtensions)

- (Color4f)color4f;
- (Color4ub)color4ub;

@end
