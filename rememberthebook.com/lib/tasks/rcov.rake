namespace :rcov do

  desc "Run rcovf for tests"
  task :info do
    ruby "-Ilib -S rcov --text-report --save coverage.info test/test_*.rb"
  end
  
  desc "Merge FILE=file with ./coverage.info"
  task :overlay do
    rcov, eol = Marshal.load(File.read("coverage.info")).last[ENV["FILE"]], 1
    puts rcov[:lines].zip(rcov[:coverage]).map { |line, coverage|
      bol, eol = eol, eol + line.length
      [bol, eol, "#ffcccc"] unless coverage
    }.compact.inspect
  end

end

