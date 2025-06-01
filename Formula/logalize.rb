class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.4.8",
    revision: "36f28d868771c49a055b581b47ce1e4b06211431"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.4.8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c700016f0dd0e4443628a0fe0b6308717f6803d5616e885ed045c93fcba53df3"
    sha256 cellar: :any_skip_relocation, ventura:       "6f96e58506680025632c17ab2acd0e04286f62e36d7d44a843c8a9ce3f7c7a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c563a8a033efc0719496c33f397df877e179982e3e856f91d1d882abeace4459"
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
