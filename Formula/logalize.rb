class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.5.0",
    revision: "fb956d75c7f3ae9c3040ba82fed6465a6b919ef7"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.5.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3453b1fc98cc7faf9a8e2ac32dcefc3d5a928cffdbbf4f906d62862c7b9ea4e0"
    sha256 cellar: :any_skip_relocation, ventura:       "1f6db1bcf7dd45089ef1cbafe93bbb4bb6be03ee16b89ff770d0615bb124ab46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e30b7eccbfa5e1cc8cf05fb6b5114985553bd99b127cfcefe8d531390fc29683"
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
