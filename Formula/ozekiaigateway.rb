class Ozekiaigateway < Formula
  desc "Ozeki AI Gateway web files for Apache/PHP"
  homepage "https://ozeki.hu"
  version "1.0.2"
  url "https://repo.ozeki.hu/pool/main/o/ozekiaigateway/ozekiaigateway_1.0.2.tar"
  
  sha256 "302efb531cfd194e6362dadf174cadb3d5199cfa68bcdf364f22f53d5d2ca897"

  depends_on "httpd"
  depends_on "php"

  def install
    
    unpack_dir = Pathname.pwd  
    
    www_dir = "#{HOMEBREW_PREFIX}/var/www"
    mkdir_p www_dir
    
    cp_r "ozeki", www_dir, verbose: true
    cp_r "ozekiservices", www_dir, verbose: true

  end

  def post_install
    www_dir = "#{HOMEBREW_PREFIX}/var/www"
    
    (www_dir).mkpath unless Dir.exist?(www_dir)
    
    chmod 0755, www_dir
    chown ENV["USER"], OS.mac? ? "_www" : "www-data", www_dir, recursive: true
    
    system "#{HOMEBREW_PREFIX}/bin/brew", "services", "restart", "httpd" if service_running?("httpd")
    system "#{HOMEBREW_PREFIX}/bin/brew", "services", "restart", "php" if service_running?("php")
  end

  def service_running?(name)
    system "brew", "services", "list", name, "|", "grep", "^#{name}.*started"
  end

  test do
    www_dir = "#{HOMEBREW_PREFIX}/var/www"
    assert_predicate Pathname(www_dir), :exist?, "WWW dir created"
    assert_predicate Pathname("#{www_dir}/index.php"), :exist?, "Web files installed" 
  end
end