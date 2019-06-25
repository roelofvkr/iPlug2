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
{
public:
  TestMTControl(IRECT bounds)
   : IControl(bounds)
  {
  }
  
  void Draw(IGraphics& g) override
  {
    g.DrawRect(COLOR_BLACK, mRECT);
    
    if (g.CheckLayer(mLayer))
    {
      g.ResumeLayer(mLayer);
    
      WDL_String str;

      for (auto& el : mBlobs)
      {
        float x = mRECT.L + (el.second.x * mRECT.W());
        float y = mRECT.T + (el.second.y * mRECT.H());
        float dim = el.second.radius > 0.f ? el.second.radius : 50.f;
        IRECT r {x-dim,y-dim,x+dim, y+dim};
        g.FillEllipse(el.second.color, r);
        g.DrawEllipse(COLOR_BLACK, r);
        str.SetFormatted(5, "%i", el.second.idx);
        g.DrawText(IText(40.f), str.Get(), r);
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
    mBlobs.insert(std::make_pair(mod.idx, Blob(mCount, x, y, mod.radius, GetRainbow(mCount))));
    mCount++;
//    OnMouseDrag(x, y, 0., 0., mod);
  }

  void OnMouseUp(float x, float y, const IMouseMod& mod) override
  {
    mCount--;
    mBlobs.erase(mod.idx);
    SetDirty(true);
  }

  void OnMouseDrag(float x, float y, float dx, float dy, const IMouseMod& mod) override
  {
    mBlobs[mod.idx].x = (x - mRECT.L) / mRECT.W();
    mBlobs[mod.idx].y = (y - mRECT.T) / mRECT.H();
    mBlobs[mod.idx].radius = mod.radius;
    SetDirty(true);
  }

public:
  struct Blob {
    int idx = 0;
    float x = 0.f;
    float y = 0.f;
    float radius = 1.f;
    IColor color = COLOR_BLACK;
    
    Blob(int idx, float x, float y, float radius, IColor color)
    : idx(idx), x(x), y(y), radius(radius), color(color)
    {}
    
    Blob()
    {}
  };
  
  int mCount = 0;
  std::map<uintptr_t, Blob> mBlobs;
  ILayerPtr mLayer;
};
