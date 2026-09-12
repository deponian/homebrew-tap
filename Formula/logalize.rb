class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.8.2",
    revision: "4a4647c4352cb6054e290b04605972e94daa50c2"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.8.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0ba352a59a33ac9abec945cc1637efdb49abc8df504d37a7ffa629592a70025"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8041902671e539ba592c59af2f25bf423d9ce2420c606e6ac90a17e16378f694"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2c025e3dec488d1d544b6f68fa06a71a2361a1c109d66dc415d6c5b36885f88"
    sha256 cellar: :any,                 x86_64_linux:  "cb301065e61860e739e32dee136167f39ad57bae42644fbff14083d979c47ee1"
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
