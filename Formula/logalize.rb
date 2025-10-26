class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.7.1",
    revision: "e2074d92788154891ee925273b06db0eaff9cac6"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.7.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5115e25d7e4a68852a93d23fa89a5e9fb0aefa596a7deaabcb09fc94be05f6d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "621e67b0c9ab5de64b4077548f823b9defdc03b1a6f267083a4c4dbcfac9924b"
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
