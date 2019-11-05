function (iplug_build_app TARGET)

  message("BUILDING ${TARGET}-app")

  if(NOT IPLUG_PLUGIN_SOURCES)
    message(FATAL_ERROR "Please set IPLUG_PLUGIN_SOURCES to the source files of your plugin")
  endif()

  if(NOT IPLUG_PLUGIN_INCLUDES)
    message(FATAL_ERROR "Please set IPLUG_PLUGIN_INCLUDES to the include folders of your plugin")
  endif()

  set (IPLUG_APP_INCLUDES
    ${IPLUG_INCLUDES}
    # APP INCLUDES
    ${IPLUG_PATH}/APP
    ${IPLUG_DEPENDENCIES_PATH}/RTAudio/include
    ${IPLUG_DEPENDENCIES_PATH}/RTAudio
    ${IPLUG_DEPENDENCIES_PATH}/RTMidi

    ${IPLUG_PLUGIN_INCLUDES}
  )

  set (IPLUG_APP_SOURCES
    ${IPLUG_SOURCES}

    ${IPLUG_DEPENDENCIES_PATH}/RTAudio/include/asio.cpp
    ${IPLUG_DEPENDENCIES_PATH}/RTAudio/include/asiodrivers.cpp
    ${IPLUG_DEPENDENCIES_PATH}/RTAudio/include/asiolist.cpp
    ${IPLUG_DEPENDENCIES_PATH}/RTAudio/include/iasiothiscallresolver.cpp
    ${IPLUG_DEPENDENCIES_PATH}/RTAudio/RtAudio.cpp
    ${IPLUG_DEPENDENCIES_PATH}/RTMidi/RtMidi.cpp

    ${IPLUG_PATH}/APP/IPlugAPP.cpp
    ${IPLUG_PATH}/APP/IPlugAPP_dialog.cpp
    ${IPLUG_PATH}/APP/IPlugAPP_host.cpp
    ${IPLUG_PATH}/APP/IPlugAPP_main.cpp

    ${IPLUG_PLUGIN_SOURCES}
  )


  add_executable(${TARGET}-app WIN32 ${IPLUG_APP_SOURCES})


  target_include_directories(${TARGET}-app PUBLIC ${IPLUG_APP_INCLUDES})

  target_link_libraries(${TARGET}-app ${IPLUG_COMMON_LIBRARIES} ${IPLUG_LIBS})
  target_compile_definitions(${TARGET}-app PUBLIC APP_API PUBLIC __WINDOWS_DS__ PUBLIC __WINDOWS_MM__ PUBLIC __WINDOWS_ASIO__ PUBLIC IPLUG_EDITOR=1 PUBLIC IPLUG_DSP=1 PUBLIC WIN32 PUBLIC _CRT_SECURE_NO_DEPRECATE PUBLIC _CRT_NONSTDC_NO_DEPRECATE PUBLIC NOMINMAX PUBLIC _MBCS)

  set_output_dir(${TARGET} "app")
  if (IPLUG_IS_64bit)
    set_target_properties(${TARGET}-app PROPERTIES OUTPUT_NAME ${TARGET}-x64)
  else()
    set_target_properties(${TARGET}-app PROPERTIES OUTPUT_NAME ${TARGET}-x86)
  endif()

endfunction(iplug_build_app)