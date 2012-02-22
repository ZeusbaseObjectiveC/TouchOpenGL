//
//  COpenGLAsset.h
//  GLCameraTest
//
//  Created by Jonathan Wight on 2/21/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol COpenGLAsset <NSObject>

@property (readonly, nonatomic, assign) GLint name;

- (void)load;
- (void)invalidate;

@end
