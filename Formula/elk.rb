class Elk < Formula
  desc "Complete LC-3 toolchain"
  homepage "https://codeberg.org/dxrcy/elk"
  license "GPLv3"

  meta = JSON.parse(File.read("#{__dir__}/../version.json"))
  version meta["version"]

  livecheck do
    url "https://github.com/dxrcy/elk/releases/latest"
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/dxrcy/elk/releases/download/v#{version}/elk-macos-arm64"
      sha256 meta["sha256"]["macos-arm64"]
    end

    on_intel do
      url "https://github.com/dxrcy/elk/releases/download/v#{version}/elk-macos-x64"
      sha256 meta["sha256"]["macos-x64"]
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dxrcy/elk/releases/download/v#{version}/elk-linux-x64"
      sha256 meta["sha256"]["linux-x64"]
    end
  end

  def install
    bin.install(Dir["elk-*"].first => "elk")
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
