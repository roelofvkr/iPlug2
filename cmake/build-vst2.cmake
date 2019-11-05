function (iplug_build_vst2 TARGET)

  message("BUILDING ${TARGET}-vst")

  if(NOT IPLUG_PLUGIN_SOURCES)
    message(FATAL_ERROR "Please set IPLUG_PLUGIN_SOURCES to the source files of your plugin")
  endif()

  if(NOT IPLUG_PLUGIN_INCLUDES)
    message(FATAL_ERROR "Please set IPLUG_PLUGIN_INCLUDES to the include folders of your plugin")
  endif()

  set (IPLUG_VST2_INCLUDES
    ${IPLUG_INCLUDES}
    ${IPLUG_DEPENDENCIES_PATH}/VST2_SDK
    ${IPLUG_PATH}/VST2

    ${IPLUG_PLUGIN_INCLUDES}
  )

  set (IPLUG_VST2_SOURCES
    ${IPLUG_SOURCES}
    ${IPLUG_PATH}/VST2/IPlugVST2.cpp
    ${IPLUG_PLUGIN_SOURCES}
  )


  add_library(${TARGET}-vst2 SHARED ${IPLUG_VST2_SOURCES})


  target_include_directories(${TARGET}-vst2 PUBLIC ${IPLUG_VST2_INCLUDES})

  target_link_libraries(${TARGET}-vst2 ${IPLUG_COMMON_LIBRARIES} ${IPLUG_LIBS})
  target_compile_definitions(${TARGET}-vst2 PUBLIC VST2_API PUBLIC IPLUG_EDITOR=1 PUBLIC VST_FORCE_DEPRECATED PUBLIC IPLUG_DSP=1 PUBLIC WIN32 PUBLIC _CRT_SECURE_NO_DEPRECATE PUBLIC _CRT_NONSTDC_NO_DEPRECATE PUBLIC NOMINMAX PUBLIC _MBCS)

  set_output_dir(${TARGET} "vst2")
  if (IPLUG_IS_64bit)
    set_target_properties(${TARGET}-vst2 PROPERTIES OUTPUT_NAME ${TARGET}-x64)
  else()
    set_target_properties(${TARGET}-vst2 PROPERTIES OUTPUT_NAME ${TARGET}-x86)
  endif()


endfunction(iplug_build_vst2)