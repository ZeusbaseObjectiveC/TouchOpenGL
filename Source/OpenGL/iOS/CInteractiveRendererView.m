//
//  CInteractiveRendererView.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/09/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CInteractiveRendererView.h"

#import <CoreMotion/CoreMotion.h>

#import "OpenGLTypes.h"
#import "CArcBall.h"
#import "Quaternion.h"

@interface CInteractiveRendererView ()
@property (readwrite, nonatomic, assign) Quaternion motionRotation;
@property (readwrite, nonatomic, assign) Quaternion gestureRotation;
@property (readwrite, nonatomic, assign) Quaternion savedRotation;
@property (readwrite, nonatomic, assign) CGFloat scale;
@property (readwrite, nonatomic, retain) CArcBall *arcBall;
@property (readwrite, nonatomic, retain) CMMotionManager *motionManager;

- (void)pinch:(UIPinchGestureRecognizer *)inGestureRecognizer;
- (void)pan:(UIPanGestureRecognizer *)inGestureRecognizer;
@end

@implementation CInteractiveRendererView

@synthesize motionRotation;
@synthesize gestureRotation;
@synthesize savedRotation;
@synthesize scale;
@synthesize arcBall;
@synthesize motionManager;

- (id)initWithFrame:(CGRect)inFrame;
    {    
    if ((self = [super initWithFrame:inFrame]))
        {
        
        arcBall = [[CArcBall alloc] init];
        
        scale = 1.0;
        
        UIPinchGestureRecognizer *thePinchGestureRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)] autorelease];
        [self addGestureRecognizer:thePinchGestureRecognizer];

        UIPanGestureRecognizer *thePanGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)] autorelease];
        [self addGestureRecognizer:thePanGestureRecognizer];
        
        motionManager = [[CMMotionManager alloc] init];
        [motionManager startDeviceMotionUpdates];

        savedRotation = QuaternionIdentity;
        }

    return self;
    }
    
- (id)initWithCoder:(NSCoder *)inDecoder
    {    
    if ((self = [super initWithCoder:inDecoder]) != NULL)
        {

        arcBall = [[CArcBall alloc] init];
        
        scale = 1.0;
        
        UIPinchGestureRecognizer *thePinchGestureRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)] autorelease];
        [self addGestureRecognizer:thePinchGestureRecognizer];

        UIPanGestureRecognizer *thePanGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)] autorelease];
        [self addGestureRecognizer:thePanGestureRecognizer];
        
        motionManager = [[CMMotionManager alloc] init];
        [motionManager startDeviceMotionUpdates];

        savedRotation = QuaternionIdentity;
        }

    return self;
    }
    

    
- (void)dealloc
    {
    [arcBall release];
    arcBall = NULL;
    
    [motionManager release];
    motionManager = NULL;
    //
    [super dealloc];
    }

- (void)render
    {
    CMDeviceMotion *theDeviceMotion = self.motionManager.deviceMotion;		

    CMQuaternion theCMRotation = theDeviceMotion.attitude.quaternion;
    
    self.motionRotation = (Quaternion){ theCMRotation.x, theCMRotation.y, theCMRotation.z, theCMRotation.w };

    Matrix4 theTransform = Matrix4MakeScale(self.scale, self.scale, self.scale);

    theTransform = Matrix4Concat(Matrix4FromQuaternion(self.motionRotation), theTransform);
    theTransform = Matrix4Concat(Matrix4FromQuaternion(self.gestureRotation), theTransform);
    self.transform = theTransform;
    
//    NSLog(@"%@", NSStringFromMatrix4(self.transform));
//    NSLog(@"%@", NSStringFromQuaternion(self.motionRotation));

    [super render];
    }



- (void)pinch:(UIPinchGestureRecognizer *)inGestureRecognizer
    {
//    NSLog(@"PINCH");
    
    self.scale += inGestureRecognizer.velocity / 10;
    }

- (void)pan:(UIPanGestureRecognizer *)inGestureRecognizer
    {
//    NSLog(@"PAN: %d", inGestureRecognizer.state);
    
    CGSize theSize = self.bounds.size;
    CGPoint theLocation = [inGestureRecognizer locationInView:self];

    const CGFloat kTrackBallRadius = 3.0f;
    const CGFloat kMousePointScale = 1.0f / kTrackBallRadius;
    CGPoint thePoint = {
        .x = 2.0f * kMousePointScale * theLocation.x / theSize.width - kMousePointScale,
        .y = (2.0f * kMousePointScale * theLocation.y / theSize.height - kMousePointScale) * -1.0,
        };

    if (inGestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
        [self.arcBall start:thePoint];
        
//        self,transgo
        }
    else if (inGestureRecognizer.state == UIGestureRecognizerStateChanged)
        {
        [self.arcBall dragTo:thePoint];
        
        self.gestureRotation = QuaternionMultiply(self.savedRotation, self.arcBall.rotation);
        }
    else if (inGestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
        self.savedRotation = self.gestureRotation;
        }
    }

@end
