class TbbAT2019U9 < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/intel/tbb/archive/2019_U9.tar.gz"
  version "2019_U9"
  # sha256 "15652f5328cf00c576f065e5cd3eaf3317422fe82afb67a9bcec0dc065bd2abe"
  sha256 "3f5ea81b9caa195f1967a599036b473b2e7c347117330cda99b79cfcf5b77c84"

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python"

  patch :DATA

  def install
    compiler = (ENV.compiler == :clang) ? "clang" : "gcc"
    system "make", "tbb_build_prefix=BUILDPREFIX", "compiler=#{compiler}"
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]

    # Build and install static libraries
    system "make", "tbb_build_prefix=BUILDPREFIX", "compiler=#{compiler}",
                   "extra_inc=big_iron.inc"
    lib.install Dir["build/BUILDPREFIX_release/*.a"]
    include.install "include/tbb"

    cd "python" do
      ENV["TBBROOT"] = prefix
      system "python3", *Language::Python.setup_install_args(prefix)
    end

    system "cmake", "-DINSTALL_DIR=lib/cmake/TBB",
                    "-DSYSTEM_NAME=Darwin",
                    "-DTBB_VERSION_FILE=#{include}/tbb/tbb_stddef.h",
                    "-P", "cmake/tbb_config_installer.cmake"

    (lib/"cmake"/"TBB").install Dir["lib/cmake/TBB/*.cmake"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tbb/task_scheduler_init.h>
      #include <iostream>

      int main()
      {
        std::cout << tbb::task_scheduler_init::default_num_threads();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltbb", "-o", "test"
    system "./test"
  end
end

# See https://github.com/oneapi-src/oneTBB/issues/186
__END__
diff --git a/src/tbb/tools_api/ittnotify_config.h b/src/tbb/tools_api/ittnotify_config.h
index 84af62d..03ac5d1 100644
--- a/src/tbb/tools_api/ittnotify_config.h
+++ b/src/tbb/tools_api/ittnotify_config.h
@@ -331,7 +331,7 @@ ITT_INLINE long
 __itt_interlocked_increment(volatile long* ptr) ITT_INLINE_ATTRIBUTE;
 ITT_INLINE long __itt_interlocked_increment(volatile long* ptr)
 {
-    return __TBB_machine_fetchadd4(ptr, 1) + 1L;
+    return __atomic_fetch_add(ptr, 1L, __ATOMIC_SEQ_CST) + 1L;
 }
 #endif /* ITT_SIMPLE_INIT */
 #endif /* ITT_PLATFORM==ITT_PLATFORM_WIN */
