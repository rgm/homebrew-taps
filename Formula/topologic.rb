# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Topologic < Formula
  desc "Topologic is a software modelling library enabling hierarchical and topological representations of architectural spaces, buildings and artefacts through non-manifold topology."
  homepage "https://topologic.app"
  url "https://github.com/wassimj/Topologic/archive/b35b911.tar.gz"
  version "2022-03-30"
  sha256 "39ec735c964154ea8029ed6bd653e32abcfd9f3b575cd8e02017e655e766cd68"
  license "GNU Affero General Public License v3.0"

  depends_on "cmake" => :build
  depends_on "rgm/taps/opencascade@7.5.3"

  patch :DATA

  def install
    ENV.deparallelize  # if your formula fails when building in parallel
    system "cmake", "-S", ".", "-B", "build",
      "-DOCC_INCLUDE_DIR=#{Formula["rgm/taps/opencascade@7.6.1"].opt_prefix}/include/opencascade",
      "-DCMAKE_SYSTEM_PROCESSOR=arm64",
      "-DCMAKE_OSX_ARCHITECTURES=arm64",
      "-DCMAKE_VS_PLATFORM_NAME=m1",
      *std_cmake_args
    system "cmake", "--build", "build"
    # system "cmake", "--install", "build"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test topologic`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end


__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index b431e28..2f0456f 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -21,7 +21,8 @@ message("${CMAKE_VS_PLATFORM_NAME} architecture in use")
 
 if(NOT ("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "Any CPU"
      OR "${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x64"
-     OR "${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x86"))
+     OR "${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x86"
+     OR "${CMAKE_VS_PLATFORM_NAME}" STREQUAL "m1"))
     message(FATAL_ERROR "${CMAKE_VS_PLATFORM_NAME} arch is not supported!")
 endif()
 
diff --git a/TopologicCore/CMakeLists.txt b/TopologicCore/CMakeLists.txt
index 5656ab5..e230790 100644
--- a/TopologicCore/CMakeLists.txt
+++ b/TopologicCore/CMakeLists.txt
@@ -192,6 +192,11 @@ elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x86")
         OUTPUT_DIRECTORY_DEBUG   "${CMAKE_SOURCE_DIR}/output/${CMAKE_VS_PLATFORM_NAME}/$<CONFIG>/"
         OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/output/${CMAKE_VS_PLATFORM_NAME}/$<CONFIG>/"
     )
+elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "m1")
+    set_target_properties(${PROJECT_NAME} PROPERTIES
+        OUTPUT_DIRECTORY_DEBUG   "${CMAKE_SOURCE_DIR}/output/${CMAKE_VS_PLATFORM_NAME}/$<CONFIG>/"
+        OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/output/${CMAKE_VS_PLATFORM_NAME}/$<CONFIG>/"
+    )
 endif()
 if("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "Any CPU")
     set_target_properties(${PROJECT_NAME} PROPERTIES
@@ -205,6 +210,10 @@ elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x86")
     set_target_properties(${PROJECT_NAME} PROPERTIES
         INTERPROCEDURAL_OPTIMIZATION_RELEASE "TRUE"
     )
+elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "m1")
+    set_target_properties(${PROJECT_NAME} PROPERTIES
+        INTERPROCEDURAL_OPTIMIZATION_RELEASE "TRUE"
+    )
 endif()
 ################################################################################
 # Include directories
@@ -257,6 +266,11 @@ elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x86")
         "${CMAKE_CURRENT_SOURCE_DIR}/include;"
         ${OCC_INCLUDE_DIR}
     )
+elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "m1")
+    target_include_directories(${PROJECT_NAME} PUBLIC
+        "${CMAKE_CURRENT_SOURCE_DIR}/include;"
+        ${OCC_INCLUDE_DIR}
+    )
 endif()
 
 ################################################################################
@@ -283,6 +297,12 @@ elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x86")
         "_WINDLL;"
         "_MBCS"
     )
+elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "m1")
+    target_compile_definitions(${PROJECT_NAME} PRIVATE
+        "TOPOLOGIC_EXPORTS;"
+        "_WINDLL;"
+        "_MBCS"
+    )
 endif()
 
 ################################################################################
@@ -467,6 +487,24 @@ elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x86")
     "TKMath;"
     "uuid;"
     )
+elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "m1")
+    set(ADDITIONAL_LIBRARY_DEPENDENCIES
+      "TKBrep;"
+      "TKStep;"
+    "TKOffset;"
+    "TKPrim;"
+    "TKMesh;"
+    "TKBO;"
+    "TKShHealing;"
+    "TKG3d;"
+    "TKG2d;"
+    "TKGeomBase;"
+    "TKGeomAlgo;"
+    "TKTopAlgo;"
+    "TKernel;"
+    "TKMath;"
+    "uuid;"
+    )
 endif()
 
 if (MSVC OR APPLE)

