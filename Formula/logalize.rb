class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.4.2",
    revision: "46164ee0e7df29251f3e5d9089dc3b506fa5eedd"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.4.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33f77f4260aad1c9eb4c3955ff56a8671254cc210cad0367d8d5bf4395b774b2"
    sha256 cellar: :any_skip_relocation, ventura:       "46991b960b4ab54c0dc0ca6389bc1643dfa56df0013687c626aebc6c5ce02b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b84f504f9673eca4c0f1aefb1e16aeae2a6c78d979feef72036694e4eba4b40b"
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
