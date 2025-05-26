class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.4.6",
    revision: "015cb1f6617141482b101f19f1ffb69a0879ec62"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.4.6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77e6cfcd4a24f2fa05536347d6919ee3cc394d4fd39eca330109ba1446e49421"
    sha256 cellar: :any_skip_relocation, ventura:       "8838a5d090d64a5e7f21ff5b31a0fb7581613044e84b176d0bf85015c8f4d840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0b794a8c99f70931b855f6ed406829fab563d79a90def029ca470b0cd112b98"
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
    assert_match "\e[;1mhello\e[0m\n", pipe_output("#{bin}/logalize -t test", "hello")
  end
end
