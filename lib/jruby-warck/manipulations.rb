require 'rake'
require 'erb'
require 'jruby-warck/constants'

module JrubyWarck::Manipulations
  include JrubyWarck::Constants

  def create_archive_dirs
    puts "++ Creating archive directories"    
    mkdir_p "#{BUILD_DIR}/assets" if Rake::Task.task_defined?("assets:precompile")
    mkdir_p WEB_INF
    mkdir_p META_INF
  end

  def add_manifest_file
    puts "++ Adding MANIFEST to #{META_INF}"
    manifest = File.new(META_INF + "/MANIFEST.MF", "w")
    manifest.puts(MANIFEST_MF)
    manifest.close
  end

  def generate_deployment_descriptor(path, framework = :rack)
    puts "++ Generating web.xml"
    context_listener = CONTEXT_LISTENERS[framework.to_sym]

    web_xml = File.new(path, "w")
    web_xml.puts(ERB.new(WEB_XML).result(binding))
    web_xml.close
  end

  def add_deployment_descriptor(framework = :rack)
    web_xml_path = "web.xml"

    # if there is no web.xml file, generate it
    generate_deployment_descriptor(web_xml_path, framework) if !File.exist?(web_xml_path)
    
    puts "++ Adding web.xml to #{WEB_INF}"
    cp web_xml_path, "#{WEB_INF}"
  end

  def add_rackup_file
    puts "++ Copying #{RACKUP_FILE} to #{WEB_INF}"
    cp RACKUP_FILE, WEB_INF
  end

  def add_ruby_files
    @ruby_files  = FileList["**/*.rb"]
    puts "++ Copying #{@ruby_files.size} Ruby sources to #{WEB_INF}"
  
    @ruby_files.each do |file|
      mkdir_p file.pathmap(WEB_INF + "/%d") unless File.exists? file.pathmap(WEB_INF + "/%d")
      cp file, (WEB_INF + "/" + file)
    end
  end

  def add_class_files
    puts "++ Moving .class files to #{WEB_INF}"
    puts "++ Generating .rb stubs in #{WEB_INF}"

    @class_files.each do |file|
      mkdir_p file.pathmap(WEB_INF + "/%d") unless File.exists? file.pathmap(WEB_INF + "/%d")
      mv file, (WEB_INF + "/" + file)

      stub = File.open((WEB_INF + "/" + file).sub(/\.class$/, ".rb"), "w")
      stub.puts("load __FILE__.sub(/\.rb$/, '.class')")
      stub.close  
    end
  end

  def add_public_files
    puts "++ Copying public files to #{BUILD_DIR}"
    
    (FileList["public/**/*"] - FileList[REJECT_FILES]).each do |file|
      if File.directory?(file)
        puts "  ++ Creating #{file.pathmap("%{public,#{BUILD_DIR}}d/%f")
}"
        mkdir_p file.pathmap("%{public,#{BUILD_DIR}}d/%f")
      else
        puts "  ++ Copying #{file.pathmap("%{public,#{BUILD_DIR}}d/%f")
}"
        cp file, file.pathmap("%{public,#{BUILD_DIR}}d/%f")
      end
    end
  end

  def add_additional_files
    puts "++ Copying additional files to #{WEB_INF}"
    FileList[SELECT_FILES].each do |file|
      mkdir_p file.pathmap("#{WEB_INF}/%d") unless File.exists?(file.pathmap("#{WEB_INF}/%d"))
      cp file, file.pathmap("#{WEB_INF}/%d/%f")
    end
  end 

  def add_bootstrap_script(archive_name)
    puts "++ Creating bootstrapping script"
    bootstrap = File.new("#{BUILD_DIR}/jar-bootstrap.rb", "w")
    # archive_name gets passed in the binding
    bootstrap.puts(ERB.new(BOOTSTRAP_ERB).result(binding))
    bootstrap.close
  end

  def archive_war(archive_name)
    puts "++ Creating war file #{archive_name}.war"

    if File.exist? "#{archive_name}.war"
      $stderr.puts "!! #{archive_name}.war already exists, aborting"
      exit 1
    end

    Zip::ZipFile.open("#{RUNNING_FROM}/#{archive_name}.war", Zip::ZipFile::CREATE) do |zip|
      Dir.chdir(BUILD_DIR)
      Dir["**/"].each { |d| zip.mkdir(d, 0744) }
      FileList["**/*"].exclude { |f| File.directory?(f) }.each { |f| puts "  ++ Adding #{f}"; zip.add(f, f) }

      zip.close
    end
  end

  def compile_ruby_scripts
    @ruby_files  = FileList["**/*.rb"]
    
    `jrubyc #{@ruby_files.join(" ")}`
    
    @class_files = FileList["**/*.class"] - FileList["tmp/**/*"]

    unless @ruby_files.size.eql?(@class_files.size)
      puts "** Warning: it seems that some ruby files were not compiled" 
      puts ".rb files: #{@ruby_files.size}"
      puts ".class files: #{@class_files.size}"
    end
  end
end
