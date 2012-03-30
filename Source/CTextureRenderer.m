//
//  CTextureRenderer.m
//  VideoFilterToy_OSX
//
//  Created by Jonathan Wight on 3/6/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import "CTextureRenderer.h"

#import "CBlitProgram.h"
#import "CBlitRectangleProgram.h"
#import "CAssetLibrary.h"
#import "CVertexBufferReference_FactoryExtensions.h"
#import "CTexture.h"
#import "CTexture_Utilities.h"

@interface CTextureRenderer ()
@property (readwrite, nonatomic, strong) CBlitRectangleProgram *rectangleProgram;
@end

#pragma mark -

@implementation CTextureRenderer

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        _projectionMatrix = Matrix4Identity;
        }
    return self;
    }

- (void)render
    {
	[super render];
	
	CTexture *theTexture = NULL;
	if (self.textureBlock != NULL)
		{
		theTexture = self.texture = self.textureBlock();
		}
	if (theTexture == NULL)
		{
		theTexture = self.texture;
		}

	if (theTexture != NULL)
		{
		#if TARGET_OS_IPHONE == 0
		if (theTexture.target == GL_TEXTURE_RECTANGLE_ARB)
			{
			if (self.rectangleProgram == NULL)
				{
				self.rectangleProgram = [[CBlitRectangleProgram alloc] init];
				[self.rectangleProgram use];
				}
			[self.rectangleProgram use];
			self.rectangleProgram.texCoords = [CVertexBufferReference vertexBufferReferenceWithRect:(CGRect){ .size = { theTexture.size.width, theTexture.size.height } }];
			self.rectangleProgram.positions = [CVertexBufferReference vertexBufferReferenceWithRect:(CGRect){ -1, -1, 2, 2 }];
			self.rectangleProgram.texture0 = theTexture;
			self.rectangleProgram.projectionMatrix = self.projectionMatrix;
			[self.rectangleProgram update];
			}
		else
		#endif /* TARGET_OS_IPHONE == 0 */
			{
			if (self.program == NULL)
				{
				self.program = [[CBlitProgram alloc] init];
				}
			[self.program use];
			self.program.texCoords = [CVertexBufferReference vertexBufferReferenceWithRect:(CGRect){ .size = { 1.0, 1.0 } }];
			self.program.positions = [CVertexBufferReference vertexBufferReferenceWithRect:(CGRect){ -1, -1, 2, 2 }];
			self.program.projectionMatrix = self.projectionMatrix;
			self.program.texture0 = theTexture;
			[self.program update];
			}

		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		glFlush();
		}
	}

@end


