# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Topologic < Formula
  desc "Topologic is a software modelling library enabling hierarchical and topological representations of architectural spaces, buildings and artefacts through non-manifold topology."
  homepage "https://topologic.app"
  url "https://github.com/rgm/Topologic/archive/2261318.tar.gz"
  version "2022-03-30"
  sha256 "e872a3d26dc433a5c5783b20160df3db77801fbd84da400f6438b386b62b2fbe"
  license "GNU Affero General Public License v3.0"

  depends_on "cmake" => :build
  depends_on "rgm/taps/opencascade@7.5.3"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "cmake", "-S", ".", "-B", "build",
      "-DOCC_INCLUDE_DIR=#{Formula["rgm/taps/opencascade@7.5.3"].opt_prefix}/include/opencascade",
      "-DCMAKE_VS_PLATFORM_NAME=m1",
      *std_cmake_args
      # "-DCMAKE_SYSTEM_PROCESSOR=arm64",
      # "-DCMAKE_OSX_ARCHITECTURES=arm64",
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
