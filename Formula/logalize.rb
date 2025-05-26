class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.4.5",
    revision: "9650c7c8a7724dff1a532fcb92e5eafe5cb80bad"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.4.4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "777cab72b6812c3f6aaefe14c6e30551eda3848c5eb183d3b063d98f9ee00e3e"
    sha256 cellar: :any_skip_relocation, ventura:       "4c7943b12dad0cef45dcd65dfbbe65cbb3e1ec297aa2457bc2028bf6bf183fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69e5707894b9361120e3a3d85dc7b45c73a4ef4eb7991f1cdfdc0aee9c2a304b"
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
