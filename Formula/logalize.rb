class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.6.1",
    revision: "9aae8b964718e939d3195c421654da802d93dcb9"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.6.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2906638b803ba746c2a206205de7e35275c344d4c460663424f46f723531b01"
    sha256 cellar: :any_skip_relocation, ventura:       "8aff945bf3b29087826ec0f4edf7f0447611bafaee10cd38a6bbe9c235529bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37eba52f9f10cf89b73b5de65610ae13c7168ef5c1ff9ad8c12702f4a4c81aee"
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
