class Mcrl < Formula
  desc "Lift Minecraft's account chat restriction across every loader/version"
  homepage "https://github.com/Sm0keSkreen/mcrl"
  url "https://github.com/Sm0keSkreen/mcrl/releases/download/v1.3.0/mcrl.jar"
  sha256 "5aef45822d86b2adf8ccfae1e01cb780bc22778e22d37b46a42a005f878ad9ad"
  license "MIT"

  depends_on "openjdk" => :test

  def install
    libexec.install "mcrl.jar"
  end

  def caveats
    <<~EOS
      mcrl.jar is installed at:
        #{opt_libexec}/mcrl.jar

      That path stays stable across upgrades (`brew upgrade mcrl` swaps the jar in
      place), so the one-time setup below never needs to be redone.

      1) Point JDK_JAVA_OPTIONS at it. On macOS (LaunchAgent, active immediately):
           launchctl setenv JDK_JAVA_OPTIONS '-javaagent:"#{opt_libexec}/mcrl.jar"'
           (add a LaunchAgent plist calling the same `launchctl setenv` so it survives
           reboots; see the mcrl README for the exact plist)
         On Linux with systemd (~/.config/environment.d/mcrl.conf):
           JDK_JAVA_OPTIONS=-javaagent:"#{opt_libexec}/mcrl.jar"

      2) Want the Realms/telemetry/profanity extras? Writes config.json right next to
         this jar, no separate download or install directory:
           curl -fsSL https://github.com/Sm0keSkreen/mcrl/releases/latest/download/install.sh \\
             | bash -s -- --configure-only "#{opt_libexec}"

      Close every open Minecraft launcher window and reopen afterward.
    EOS
  end

  test do
    system formula_opt_bin("openjdk")/"java", "-javaagent:#{opt_libexec}/mcrl.jar", "-version"
  end
end
