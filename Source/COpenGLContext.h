//
//  COpenGLContext.h
//  GLCameraTest
//
//  Created by Jonathan Wight on 2/20/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLTypes.h"

@class CFrameBuffer;
@class CRenderBuffer;
@class CTexture;

@interface COpenGLContext : NSObject

#warning TODO remove size from here...
@property (readonly, nonatomic, assign) SIntSize size;
@property (readwrite, nonatomic, strong) NSString *label;

@property (readonly, nonatomic, strong) CFrameBuffer *frameBuffer;
@property (readonly, nonatomic, strong) CRenderBuffer *depthBuffer;
@property (readonly, nonatomic, strong) CRenderBuffer *colorBuffer;
@property (readonly, nonatomic, strong) CTexture *colorTexture;

@property (readonly, nonatomic, assign) BOOL isActive;

#if TARGET_OS_IPHONE == 1
@property (readonly, nonatomic, strong) EAGLContext *nativeContext;
#else
@property (readonly, nonatomic, assign) CGLContextObj nativeContext;
#endif /* TARGET_OS_IPHONE == 1 */

+ (COpenGLContext *)currentContext;

- (id)initWithSize:(SIntSize)inSize;

#if TARGET_OS_IPHONE == 1
- (id)initWithSize:(SIntSize)inSize drawable:(id <EAGLDrawable>)inDrawable;
#else
- (id)initWithNativeContext:(CGLContextObj)inNativeContext size:(SIntSize)inSize;
#endif

- (void)setupForOffscreen;

- (void)setupFrameBuffer;

- (void)use;
- (void)unuse;

- (void)present;

- (CTexture *)readTexture;

@end
