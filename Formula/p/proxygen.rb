class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.06.10.00/proxygen-v2024.06.10.00.tar.gz"
  sha256 "a2bebfcab5107d6abf477e0bb8d391cbc8801c497bb851f2441767fc03cc7755"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ceb9159753e045bcde686a927b3c765cdde66246d473032518b3165bb8a4fc80"
    sha256 cellar: :any,                 arm64_ventura:  "c580e70d4910614f8e1c781c0087d21293ffa4f93fbf9793d487c9303a079166"
    sha256 cellar: :any,                 arm64_monterey: "d6b05574517898ad67ee543565160212cd0ace184c22644ca17075a4106e8f61"
    sha256 cellar: :any,                 sonoma:         "52e5afbec5bceac3fde504925355564796b62dcd4e44117cf25732cbc194ba03"
    sha256 cellar: :any,                 ventura:        "c4a7a019715aec8a194965338c21e62fcf351b6dd66a0253436423416e48a5ad"
    sha256 cellar: :any,                 monterey:       "a467cf2d9f9b9b4750fdd3e904f2d27ba6e60ab381490fc16c58a6e5a4261f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "723cd95cb0b80b73a4370a9c7eedf59b2e9549f632cb1343a77c290c5fb4404a"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "libsodium"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pid = spawn bin/"proxygen_echo"
    sleep 10
    system "curl", "-v", "http://localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end
