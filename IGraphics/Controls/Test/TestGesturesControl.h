/*
 ==============================================================================

 This file is part of the iPlug 2 library. Copyright (C) the iPlug 2 developers.

 See LICENSE.txt for  more info.

 ==============================================================================
*/

#pragma once

/**
 * @file
 * @copydoc TestGesturesControl
 */

#include "IControl.h"

 /** Control to test multi gesture recognizers
  *   @ingroup TestControls */
class TestGesturesControl : public ITextControl
{
public:
  TestGesturesControl(IRECT bounds)
   : ITextControl(bounds, "Do a gesture...")
  {
    mIgnoreMouse = false;
    mText = IText(60.f);
  }
  
  void OnInit()
  {
    int idx = 1; // 0 = unknown
    for(auto& type : { EGestureType::DoubleTap,
                       EGestureType::TripleTap,
                       EGestureType::LongPress1,
                       EGestureType::LongPress2,
                       EGestureType::SwipeLeft,
                       EGestureType::SwipeRight,
                       EGestureType::SwipeUp,
                       EGestureType::SwipeDown,
                       EGestureType::Pinch,
                       EGestureType::Rotate,
                       EGestureType::Pan} )
    {
      AttachGestureRecognizer(type, [&, idx](IControl* pCaller, const IGestureInfo& info) {
        SetStr(kGestureTypeStrs[idx]);
        mBGColor = IColor::GetRandomColor();
       });
      idx++;
    }
  }
};
