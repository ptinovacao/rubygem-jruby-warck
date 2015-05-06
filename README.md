# jruby-warck

jruby-warck takes any Rack-based application builds a .war file that you can run either

  * with "java -jar" or
  * inside a servlet container (eg.Tomcat, JBoss, Jetty, etc...).

Yes, it's like Warbler, but far simpler.

## Usage

### Dependencies
  * jruby-rack

### Basic

  1. change directory to the root of your application
  2. run "rake assets:precompile" if you've a Rails application.
  3. run "warck package [war_name]" (If you need to compile the source code, use "warck package_compiled [war_name]" instead)
  4. You can now deploy the resulting jar in a servlet container or run in standalone mode, i.e, java -jar [war_name].

### Customizing what gets in the .war


When packaging, jruby-warck will include all .rb files in the web archive.

Additionally, by default it will also include all .yml and .erb files, but you can change this.

* To select which files should be packaged, create a "select.files" inside the application directory containing a glob pattern per line for the filenames you need. Note that this will override the default, so that no other files will be included.

* To keep any files from being included, create "reject.files" inside the app directory containing a glob pattern per line for the filenames you want to reject.

### Customizing classpath
By default MANIFEST.MF includes jruby-complete on the classpath. However, if your application needs to add addicional entries to classpath, create a "cp.entries" file, and specify one entry per line.

##License

jruby-warck is released under the [MIT License](http://www.opensource.org/licenses/MIT).

