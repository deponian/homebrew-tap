class Logalize < Formula
  desc "Fast and extensible log colorizer. Alternative to ccze"
  homepage "https://github.com/deponian/logalize"
  url "https://github.com/deponian/logalize.git",
    tag:      "v0.4.3",
    revision: "dafe1e0b13301793b82fb0a59097b1b103d8f6d8"
  license "MIT"
  head "https://github.com/deponian/logalize.git", branch: "main"

  bottle do
    root_url "https://github.com/deponian/homebrew-tap/releases/download/logalize-0.4.3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "addc4532dc27913f39167c095a56df35ed9f090a12c36d34e38b96cc32819e7a"
    sha256 cellar: :any_skip_relocation, ventura:       "6ddf0364bba2137f91e01b4731ee65bb22b4c7046c3aa883127d939c7558a6ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "906582da7fe72912256208412553a986132959da326202bfe5dcf5e74544b8fa"
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
