class BrewStack < Formula
  desc "External command to create fully built-as-bottle Homebrew prefix"
  homepage "https://github.com/dakcarto/homebrew-cmds/"
  url "https://github.com/dakcarto/homebrew-cmds.git"
  version "1.0.0"

  skip_clean "bin"

  def install
    bin.install "External-Cmds/brew-stack.rb"
    (bin/"brew-stack.rb").chmod 0755
    bash_completion.install "External-Cmds/brew_stack_completion.sh"
  end

  test do
    #
  end
end
