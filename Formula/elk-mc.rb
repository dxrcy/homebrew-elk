class ElkMc < Formula
  desc "Complete LC-3 toolchain with Minecraft integration"
  homepage "https://codeberg.org/dxrcy/elk"
  license "GPLv3"
  head "https://codeberg.org/dxrcy/elk.git", branch: "minecraft"

  meta = JSON.parse(File.read("#{__dir__}/../version.json"))
  version meta["version"]

  conflicts_with "elk", because: "both install `elk` binaries"
  depends_on "zig" => :build

  livecheck do
    url "https://github.com/dxrcy/elk/releases/latest"
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/dxrcy/elk/releases/download/v#{version}-mc/elk-macos-arm64"
      sha256 meta["sha256"]["mc"]["macos-arm64"]
    end

    on_intel do
      url "https://github.com/dxrcy/elk/releases/download/v#{version}-mc/elk-macos-x64"
      sha256 meta["sha256"]["mc"]["macos-x64"]
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dxrcy/elk/releases/download/v#{version}-mc/elk-linux-x64"
      sha256 meta["sha256"]["mc"]["linux-x64"]
    end
  end

  def install
    if build.head?
      system "zig", "build", "install", "-Doptimize=ReleaseSafe", "--prefix", prefix
    else
      bin.install(Dir["elk-*"].first => "elk")
    end
  end

  test do
    (testpath / "test.asm").write(
      <<~ASM
        .ORIG 0x3000
        halt
        .END
      ASM
    )

    shell_output("#{bin}/elk test.asm --assemble 2>&1")
    assert_predicate testpath / "test.obj", :exist?
  end
end
