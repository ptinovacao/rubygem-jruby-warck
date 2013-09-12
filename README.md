# jruby-warck

jruby-warck takes any Rack-based application and sticks it in a .war file that you can run either

  * with "java -jar" or
  * inside a servlet container like Tomcat, JBoss or Jetty.

Yes, it's like Warbler, but far simpler.

## Usage

### Dependencies
  * jruby-jars
  * jruby-rack

### Basic

  1. change directory to the root of your application
  2. run "rake assets:precompile" if you've a Rails application.
  3. run "warck package[war_name_here]"
    3a. if you need to compile the source code, use "warck package_compiled[war_name_here]" instead
  4. boom, a wild war_name_here.war appears!
  5. deploy in your app server or run it in the command line

### Customizing what gets in the .war

#### Files
When packaging, jruby-warck will include all .rb files in the web archive.

Additionally, by default it will also include all .yml and .erb files, but there are two ways you can use to change this.

* To select exactly what files will be brought, create a "select.files" inside the application directory containing a glob pattern per line for the filenames you need. Note that this will override the default, so that no other files will be included.

* To keep any files from being included, create "reject.files" inside the app directory containing a glob pattern per line for the filenames you want to reject.
