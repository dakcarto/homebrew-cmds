class BrewCd < Formula
  desc "External command to cd to the opt_prefix of a formula"
  homepage "https://github.com/dakcarto/homebrew-cmds/"
  url "https://github.com/dakcarto/homebrew-cmds.git"
  version "1.0.0"

  skip_clean "bin"

  def install
    bin.install "External-Cmds/brew-cd.rb"
    (bin/"brew-cd.rb").chmod 0755
    bash_completion.install "External-Cmds/brew_cd"
  end

  test do
    #
  end
end
