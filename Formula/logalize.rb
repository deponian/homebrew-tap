class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.4.8",
    revision: "36f28d868771c49a055b581b47ce1e4b06211431"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.4.7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1270d46878b9a067cafd0a431984eb0e94fa31cd83fe316e1e0bb1f732ba8013"
    sha256 cellar: :any_skip_relocation, ventura:       "92da032358443466bf6c3907d0e7c14e35368fc09ba9e5abf369cef443c0a758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "992714e9b89b9d0630bf3625c2d876ce1c1f16f96627474e2a7bba34caee32d0"
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
