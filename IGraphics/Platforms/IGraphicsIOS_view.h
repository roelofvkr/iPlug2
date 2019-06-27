/*
 ==============================================================================

 This file is part of the iPlug 2 library. Copyright (C) the iPlug 2 developers.

 See LICENSE.txt for  more info.

 ==============================================================================
*/

#import <UIKit/UIKit.h>
#include "IGraphicsIOS.h"
#include <map>

inline CGRect ToCGRect(IGraphics* pGraphics, const IRECT& bounds)
{
  float B = (pGraphics->Height() - bounds.B);
  return CGRectMake(bounds.L, B, bounds.W(), bounds.H());
}

@interface IGraphicsIOS_View : UIView <UIGestureRecognizerDelegate>
{  
@public
  IGraphicsIOS* mGraphics;
  std::map<EGestureType, IGestureFunc> mGestureFuncs;
}
- (id) initWithIGraphics: (IGraphicsIOS*) pGraphics;
- (BOOL) isOpaque;
- (BOOL) acceptsFirstResponder;
- (void) removeFromSuperview;
- (void) controlTextDidEndEditing: (NSNotification*) aNotification;
- (IPopupMenu*) createPopupMenu: (const IPopupMenu&) menu : (CGRect) bounds;
- (void) createTextEntry: (int) paramIdx : (const IText&) text : (const char*) str : (int) length : (CGRect) areaRect;
- (void) endUserInput;
- (void) showMessageBox: (const char*) str : (const char*) caption : (EMsgBoxType) type : (IMsgBoxCompletionHanderFunc) completionHandler;
- (void) attachGestureRecognizer: (EGestureType) type : (IGestureFunc) func;
- (void) onTapGesture: (UITapGestureRecognizer*) recognizer;
- (void) onLongPressGesture: (UILongPressGestureRecognizer*) recognizer;
- (void) onSwipeGesture: (UISwipeGestureRecognizer*) recognizer;
- (void) onPinchGesture: (UIPinchGestureRecognizer*) recognizer;
- (void) onRotateGesture: (UIRotationGestureRecognizer*) recognizer;
@property (readonly) CAMetalLayer* metalLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

#ifdef IGRAPHICS_IMGUI
#import <MetalKit/MetalKit.h>

@interface IGRAPHICS_IMGUIVIEW : MTKView
{
  IGraphicsIOS_View* mView;
}
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
- (id) initWithIGraphicsView: (IGraphicsIOS_View*) pView;
@end
#endif
