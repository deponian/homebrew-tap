class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.4.6",
    revision: "015cb1f6617141482b101f19f1ffb69a0879ec62"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.4.5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c00aee9e54d727a2229e32f00b72fb91dcc0cb6dfbce12a24eaa5b23667df320"
    sha256 cellar: :any_skip_relocation, ventura:       "a999ee765add22cae550a50ca6e0f024c8c8e3fa24717d911ec5a59c9a317a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c790055962d4cdc0905d65f37b23dd87dfdca6034d9e2af07e7ab704c14cf118"
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
