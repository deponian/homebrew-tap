class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.6.0",
    revision: "aa2285251b295c7d954e06f9eade3aeaf6351182"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.6.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dcc85ee2823046231e9d8ad8c0a1471da9db559261253c581b154fb739de68c"
    sha256 cellar: :any_skip_relocation, ventura:       "0c8b7d90d58de8ead782547a30777d9374d786e8744345a290f8a6745fd8e587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab52749fc55801bf82047cd090d6bae7d745477e8d6d8df97fa66d1fdd81c4a4"
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
