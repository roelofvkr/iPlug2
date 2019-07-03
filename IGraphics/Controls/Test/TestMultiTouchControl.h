/*
 ==============================================================================

 This file is part of the iPlug 2 library. Copyright (C) the iPlug 2 developers.

 See LICENSE.txt for  more info.

 ==============================================================================
*/

#pragma once

/**
 * @file
 * @copydoc TestMTControl
 */

#include "IControl.h"
#include <map>

 /** Control to test multi touch
  *   @ingroup TestControls */
class TestMTControl : public IControl
                    , public IMultiTouchControlBase
{
public:
  TestMTControl(IRECT bounds)
   : IControl(bounds)
  {
//    SetWantsMultiTouch(true);
  }
  
  void Draw(IGraphics& g) override
  {
    g.DrawRect(COLOR_BLACK, mRECT);
    
    if (g.CheckLayer(mLayer))
    {
      g.ResumeLayer(mLayer);
    
      WDL_String str;

      for (int t = 0; t < NTrackedTouches(); t++)
      {
        auto* touch = GetTouch(t);
        
        float dim = touch->radius > 0.f ? touch->radius : 50.f;
        IRECT r {touch->x-dim,touch->y-dim,touch->x+dim, touch->y+dim};
        g.FillEllipse(GetRainbow(t), r);
        g.DrawEllipse(COLOR_BLACK, r);
        Milliseconds duration =  std::chrono::high_resolution_clock::now() - touch->startTime;
        str.SetFormatted(32, "%i: %i", t, static_cast<int>(duration.count()));
        g.DrawText(IText(20.f), str.Get(), r);
      }
    }
    else{
      g.StartLayer(mRECT);
    }
    
    mLayer = g.EndLayer();
    g.DrawLayer(mLayer);
  }

  void OnMouseDown(float x, float y, const IMouseMod& mod) override
  {
    AddTouch(mod.idx, x, y, mod.radius);
  }

  void OnMouseUp(float x, float y, const IMouseMod& mod) override
  {
    ReleaseTouch(mod.idx);
    
    if(NTrackedTouches() == 0)
    {
      mLayer->Invalidate();
    }
    
    SetDirty(true);
  }

  void OnTouchCancelled(float x, float y, const IMouseMod& mod) override
  {
    OnMouseUp(x,y,mod);
  }
  
  void OnMouseDrag(float x, float y, float dx, float dy, const IMouseMod& mod) override
  {
    UpdateTouch(mod.idx, x, y, mod.radius);
    SetDirty(true);
  }

  bool IsDirty() override
  {
    if(NTrackedTouches())
      return true;
    else
      return IControl::IsDirty();
  }
  
public:
  ILayerPtr mLayer;
};
