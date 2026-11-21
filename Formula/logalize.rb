class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.9.0",
    revision: "20ad220b38071079ee3de7279f02eb165701fd9f"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.9.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f224d7aca0fef0d5710ae77b842e8759e9d3d6e947d6324af0d16b23abb219a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaefd8e928d89842dfae322706e76750a0ebe18ea0d12cb8d1e376ece6b0357f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a115e57257bb950c4c72f74f91e7c1bf34c1db10a438e61b615bc3222a10260f"
    sha256 cellar: :any,                 x86_64_linux:  "b17b8c79ce1ed2278ca707f92fd354159e91eda405fb8e8cb6d2fec8f4ab0ca6"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}", "build"
    bin.install "dist/#{version}/logalize"

    system "make", "VERSION=#{version}", "manpage"
    man1.install "manpages/logalize.1.gz"

    system "make", "completions"
    bash_completion.install "completions/logalize.bash" => "logalize"
    zsh_completion.install "completions/logalize.zsh" => "_logalize"
    fish_completion.install "completions/logalize.fish"
  end

  test do
    (testpath/".logalize.yaml").write <<~EOF
      words:
        good:
        - hello
      themes:
        test:
          words:
            good:
              fg: "#00ff00"
              style: bold
    EOF
    assert_match "\e[;1mhello\e[0m", pipe_output("#{bin}/logalize -t test", "hello")
  end
end
