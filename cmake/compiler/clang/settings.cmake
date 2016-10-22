# Set build-directive (used in core to tell which buildtype we used)
add_definitions(-D_BUILD_DIRECTIVE='"$(CONFIGURATION)"')

if(DO_WARN)
  set(WARNING_FLAGS "-W -Wall -Wextra -Winit-self -Wfatal-errors -Wno-mismatched-tags")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${WARNING_FLAGS}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${WARNING_FLAGS} -Woverloaded-virtual")
  message(STATUS "Clang: All warnings enabled")
endif()

if(DO_DEBUG)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g3")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g3 -O0")
  message(STATUS "Clang: Debug-flags set (-g3)")

  #http://clang.llvm.org/docs/AddressSanitizer.html
  if(CLANG_ADDRESS_SANITIZER)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-omit-frame-pointer -fno-optimize-sibling-calls -fsanitize=address -fno-sanitize-recover -fsanitize=return -fsanitize=bounds -fsanitize=shift -fsanitize=bool -fsanitize=enum")	
    message(STATUS "/!\ Clang: AddressSanitizer enabled. Except SLOWDOWNS on runtime.")
  endif() 
  if(CLANG_THREAD_SANITIZER)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=thread")	
    message(STATUS "/!\ Clang: ThreadSanitizer enabled. Expect LARGE SLOWDOWNS on runtime.")
  endif()
  if(CLANG_MEMORY_SANITIZER)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=memory -fno-omit-frame-pointer")	
    message(STATUS "/!\ Clang: MemorySanitizer enabled. Except SLOWDOWNS on runtime.")
  endif()
  if(CLANG_THREAD_SAFETY_ANALYSIS)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wthread-safety")	
    message(STATUS "Clang: Thread safety analysis enabled")
  endif()
endif()

# -Wno-narrowing needed to suppress a warning in g3d
# -Wno-deprecated-register is needed to suppress 185 gsoap warnings on Unix systems.
# -Wno-switch because I find this warning useless
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wno-narrowing -Wno-deprecated-register -Wno-switch")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DDEBUG=1")
