set (IPLUG2_ROOT ${CMAKE_CURRENT_LIST_DIR})
set (IPLUG_PATH ${IPLUG2_ROOT}/IPlug)
set (IPLUG_DEPENDENCIES_PATH ${IPLUG2_ROOT}/Dependencies/IPlug)

set (IGRAPHICS_PATH ${IPLUG2_ROOT}/IGraphics)
set (IGRAPHICS_DEPENDENCIES_PATH ${IPLUG2_ROOT}/Dependencies/IGraphics)

if (APPLE OR UNIX)
  message(FATAL_ERROR "Cmake not yet supported for mac or linux")
endif()

if(NOT ${CMAKE_BUILD_TYPE} STREQUAL "Release")
  message("BUILDING IN DEBUG MODE")
  add_definitions(-D_DEBUG)
else()
  add_definitions(-DNDEBUG)
endif()

set (IPLUG_INCLUDES
  # WDL PATH
  ${IPLUG2_ROOT}/WDL
  ${IPLUG_PATH}
  ${IPLUG_PATH}/Extras
  ${IPLUG_PATH}/Extras/Synth
  ${IPLUG_PATH}/Extras/Faust

  # igraphics
  ${IGRAPHICS_PATH}
  ${IGRAPHICS_PATH}/Controls
  ${IGRAPHICS_PATH}/Drawing
  ${IGRAPHICS_PATH}/Platforms
  ${IGRAPHICS_PATH}/Extras

  ${IGRAPHICS_DEPENDENCIES_PATH}/STB
  ${IGRAPHICS_DEPENDENCIES_PATH}/NanoSVG/src
  ${IPLUG2_ROOT}/WDL/libpng
  ${IPLUG2_ROOT}/WDL/zlib
  ${IPLUG2_ROOT}/Dependencies/Build/src/freetype/include

)

set (IPLUG_SOURCES
  ${IGRAPHICS_PATH}/Controls/IControls.cpp
  ${IGRAPHICS_PATH}/Controls/IPopupMenuControl.cpp
  ${IGRAPHICS_PATH}/Controls/ITextEntryControl.cpp
  ${IGRAPHICS_PATH}/IControl.cpp
  ${IGRAPHICS_PATH}/IGraphics.cpp
  ${IGRAPHICS_PATH}/IGraphicsEditorDelegate.cpp
  ${IGRAPHICS_PATH}/Platforms/IGraphicsWin.cpp

  ${IPLUG_PATH}/IPlugAPIBase.cpp
  ${IPLUG_PATH}/IPlugParameter.cpp
  ${IPLUG_PATH}/IPlugPaths.cpp
  ${IPLUG_PATH}/IPlugPluginBase.cpp
  ${IPLUG_PATH}/IPlugProcessor.cpp
  ${IPLUG_PATH}/IPlugTimer.cpp

)

set (IPLUG_COMMON_LIBRARIES
  cairo
  freetype
  libpng
  pixman
  zlib
)

set (IPLUG_IS_64bit off)

if(IGRAPHICS_GL2)
    add_definitions(-DIGRAPHICS_GL2)
    set (IPLUG_INCLUDES ${IPLUG_INCLUDES}
      ${IGRAPHICS_DEPENDENCIES_PATH}/glad_GL2/include
      ${IGRAPHICS_DEPENDENCIES_PATH}/glad_GL2/src
    )
  elseif(IGRAPHICS_GL3)
    add_definitions(-DIGRAPHICS_GL3)
    set (IPLUG_INCLUDES ${IPLUG_INCLUDES}
      ${IGRAPHICS_DEPENDENCIES_PATH}/glad_GL3/include
      ${IGRAPHICS_DEPENDENCIES_PATH}/glad_GL3/src
    )
endif()

if(IGRAPHICS_NANOVG)
  add_definitions(-DIGRAPHICS_NANOVG)
  set (IPLUG_INCLUDES ${IPLUG_INCLUDES}
    ${IGRAPHICS_DEPENDENCIES_PATH}/NanoVG/src
  )

elseif(IGRAPHICS_CAIRO)
  if (IGRAPHICS_GL2 OR IGRAPHICS_GL3)
    message(FATAL_ERROR "Don't use graphics_gl with a cairo backend")
  endif()
  add_definitions(-DIGRAPHICS_CAIRO)
  set (IPLUG_INCLUDES ${IPLUG_INCLUDES}
    ${IGRAPHICS_DEPENDENCIES_PATH}/Cairo
    ${IPLUG2_ROOT}/Dependencies/Build/src
  )

endif()

# LINK DEPENDENCIES FOR THE RIGHT PLATFORM
if(WIN32)
  set (IPLUG_COMMON_LIBRARIES ${IPLUG_COMMON_LIBRARIES}
    dsound
    winmm
    wininet
    comctl32
    Shlwapi
    kernel32
    user32
    gdi32
    winspool
    comdlg32
    advapi32
    shell32
    ole32
    oleaut32
    uuid
    odbc32
    odbccp32
  )

  if("${CMAKE_SIZEOF_VOID_P}" STREQUAL "8")
    set(IPLUG_IS_64bit on)
    link_directories(${IPLUG2_ROOT}/Dependencies/Build/win/x64/${CMAKE_BUILD_TYPE})
  else()
    link_directories(${IPLUG2_ROOT}/Dependencies/Build/win/Win32/${CMAKE_BUILD_TYPE})
  endif()

endif()

function(set_output_dir TARGET TYPE)
  set_target_properties(${TARGET}-${TYPE}
      PROPERTIES
      ARCHIVE_OUTPUT_DIRECTORY "${OUTPUT_BASE_DIR}/${TYPE}/"
      LIBRARY_OUTPUT_DIRECTORY "${OUTPUT_BASE_DIR}/${TYPE}/"
      RUNTIME_OUTPUT_DIRECTORY "${OUTPUT_BASE_DIR}/${TYPE}/"
  )
endfunction(set_output_dir)

include(${IPLUG2_ROOT}/cmake/build-app.cmake)
include(${IPLUG2_ROOT}/cmake/build-vst2.cmake)
include(${IPLUG2_ROOT}/cmake/build-vst3.cmake)