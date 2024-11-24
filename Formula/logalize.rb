class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.4.2",
    revision: "46164ee0e7df29251f3e5d9089dc3b506fa5eedd"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.4.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f2a244667a7a27e1271883b98f1e00a9db24aac6026f6a380c3529e68c1c8a5"
    sha256 cellar: :any_skip_relocation, ventura:       "7cddd5ca50a23ac33825e69a8ffa1fcfd3f3dd591cb7719388060954e92e75dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a129811edb5e93555e364f69f6a545fc8d7829d2bb9b6300eb7a5148701e270f"
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
