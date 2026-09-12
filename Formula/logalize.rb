class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.8.2",
    revision: "4a4647c4352cb6054e290b04605972e94daa50c2"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.8.1_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d38679333e81c07cb9c10e99f3bf85b939d032a435a68b03e01ca7346a97071"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3794592ea4a0d259e8e51ffcb84c0ffd039c0d1cc527071cb307481bcad41673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3896dfe116366a215287085f25ffe793a375cab308323e577cd12d9debdb2fcf"
    sha256 cellar: :any,                 x86_64_linux:  "bf6649ba226be1faf08ef2d688337d74a8993b4fc8b4747b14288b2c3bb6a606"
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
