function (iplug_build_vst3 TARGET)

  message("BUILDING ${TARGET}-vst3")
  set (IPLUG_VST3_SDK ${IPLUG_DEPENDENCIES_PATH}/VST3_SDK)


  if(NOT IPLUG_PLUGIN_SOURCES)
    message(FATAL_ERROR "Please set IPLUG_PLUGIN_SOURCES to the source files of your plugin")
  endif()

  if(NOT IPLUG_PLUGIN_INCLUDES)
    message(FATAL_ERROR "Please set IPLUG_PLUGIN_INCLUDES to the include folders of your plugin")
  endif()

  set (IPLUG_VST3_INCLUDES
    ${IPLUG_INCLUDES}
    ${IPLUG_DEPENDENCIES_PATH}/VST3_SDK
    ${IPLUG_PATH}/VST3

    ${IPLUG_PLUGIN_INCLUDES}
  )

  set (IPLUG_VST3_SOURCES
    ${IPLUG_SOURCES}

    # VST 3 SDK SOURCES
    ${IPLUG_VST3_SDK}/base/source/baseiids.cpp
    ${IPLUG_VST3_SDK}/base/source/fbuffer.cpp
    ${IPLUG_VST3_SDK}/base/source/fdebug.cpp
    ${IPLUG_VST3_SDK}/base/source/fdynlib.cpp
    ${IPLUG_VST3_SDK}/base/source/fobject.cpp
    ${IPLUG_VST3_SDK}/base/source/fstreamer.cpp
    ${IPLUG_VST3_SDK}/base/source/fstring.cpp
    ${IPLUG_VST3_SDK}/base/source/timer.cpp
    ${IPLUG_VST3_SDK}/base/source/updatehandler.cpp
    ${IPLUG_VST3_SDK}/base/thread/source/fcondition.cpp
    ${IPLUG_VST3_SDK}/base/thread/source/flock.cpp
    ${IPLUG_VST3_SDK}/pluginterfaces/base/conststringtable.cpp
    ${IPLUG_VST3_SDK}/pluginterfaces/base/coreiids.cpp
    ${IPLUG_VST3_SDK}/pluginterfaces/base/funknown.cpp
    ${IPLUG_VST3_SDK}/pluginterfaces/base/ustring.cpp
    ${IPLUG_VST3_SDK}/public.sdk/source/common/memorystream.cpp
    ${IPLUG_VST3_SDK}/public.sdk/source/common/pluginview.cpp
    ${IPLUG_VST3_SDK}/public.sdk/source/common/commoniids.cpp
    ${IPLUG_VST3_SDK}/public.sdk/source/main/dllmain.cpp
    ${IPLUG_VST3_SDK}/public.sdk/source/main/pluginfactory.cpp
    ${IPLUG_VST3_SDK}/public.sdk/source/vst/vstaudioeffect.cpp
    ${IPLUG_VST3_SDK}/public.sdk/source/vst/vstbus.cpp
    ${IPLUG_VST3_SDK}/public.sdk/source/vst/vstcomponent.cpp
    ${IPLUG_VST3_SDK}/public.sdk/source/vst/vstcomponentbase.cpp
    ${IPLUG_VST3_SDK}/public.sdk/source/vst/vstinitiids.cpp
    ${IPLUG_VST3_SDK}/public.sdk/source/vst/vstparameters.cpp
    ${IPLUG_VST3_SDK}/public.sdk/source/vst/vstsinglecomponenteffect.cpp


    ${IPLUG_PATH}/VST3/IPlugVST3.cpp
    ${IPLUG_PATH}/VST3/IPlugVST3_ProcessorBase.cpp
    ${IPLUG_PLUGIN_SOURCES}
  )

  if(WIN32)
    set (IPLUG_VST3_SOURCES ${IPLUG_VST3_SOURCES}
      ${IPLUG_DEPENDENCIES_PATH}/VST3_SDK/public.sdk/source/main/winexport.def
    )

    set (${VST3_LIBRARIES} ${IPLUG_VST3_SDK}/public.sdk/source/main/winexport.def)
  endif()


  add_library(${TARGET}-vst3 SHARED ${IPLUG_VST3_SOURCES})


  target_include_directories(${TARGET}-vst3 PUBLIC ${IPLUG_VST3_INCLUDES})

  target_link_libraries(${TARGET}-vst3 ${IPLUG_COMMON_LIBRARIES} ${VST3_LIBRARIES} ${IPLUG_LIBS})
  target_compile_definitions(${TARGET}-vst3 PUBLIC VST3_API PUBLIC IPLUG_EDITOR=1 PUBLIC IPLUG_DSP=1 PUBLIC WIN32 PUBLIC _CRT_SECURE_NO_DEPRECATE PUBLIC _CRT_NONSTDC_NO_DEPRECATE PUBLIC NOMINMAX PUBLIC _MBCS)
  set_target_properties(${TARGET}-vst3 PROPERTIES PREFIX "" SUFFIX ".vst3")



  # set_output_dir(${TARGET} "vst3")

  if(WIN32)
    # add_custom_command(
    #   TARGET ${TARGET}-vst3
    #   POST_BUILD
    #   COMMAND ${IPLUG2_ROOT}/Scripts/create_bundle.bat
    #   ARGS "$<TARGET_FILE:${TARGET}-vst3>" ${IPLUG_VST3_SDK}/doc/artwork/VST_Logo_Steinberg.ico ".vst3"
    # )
    add_custom_command(
      TARGET ${TARGET}-vst3
      POST_BUILD
      COMMAND ${IPLUG2_ROOT}/Scripts/create_bundle.bat
      ARGS "${OUTPUT_BASE_DIR}/vst3/${TARGET}.vst3" "${IPLUG_VST3_SDK}/doc/artwork/VST_Logo_Steinberg.ico" "\".vst3\""
    )

    if (IPLUG_IS_64bit)
      add_custom_command(
          TARGET ${TARGET}-vst3
          POST_BUILD
          COMMAND ${CMAKE_COMMAND} -E copy
          $<TARGET_FILE:${TARGET}-vst3> ${OUTPUT_BASE_DIR}/vst3/${TARGET}.vst3/Contents/x86_64-win/${TARGET}.vst3)
    else()
      add_custom_command(
          TARGET ${TARGET}-vst3
          POST_BUILD
          COMMAND ${CMAKE_COMMAND} -E copy
          $<TARGET_FILE:${TARGET}-vst3> ${OUTPUT_BASE_DIR}/vst3/${TARGET}.vst3/Contents/x86-win/${TARGET}.vst3)
    endif()



  endif()

endfunction(iplug_build_vst3)