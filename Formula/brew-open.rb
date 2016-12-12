class BrewOpen < Formula
  desc "External command to open the Cellar prefix of a formula"
  homepage "https://github.com/dakcarto/homebrew-cmds/"
  url "https://github.com/dakcarto/homebrew-cmds.git"
  version "1.0.0"

  skip_clean "bin"

  def install
    bin.install "External-Cmds/brew-open.rb"
    (bin/"brew-open.rb").chmod 0755
    bash_completion.install "External-Cmds/brew_open"
  end

  test do
    #
  end
end
