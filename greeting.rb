def greeting
   greet=ARGV[0]
   ARGV.drop(1).each do |arg|
     puts "#{greet}, #{arg}!"
   end
end
greeting
