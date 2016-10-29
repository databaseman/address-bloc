require_relative '../models/address_book'

class MenuController
   attr_reader :address_book

   def initialize
     @address_book = AddressBook.new
   end

   def main_menu
     puts "Main Menu - #{address_book.entries.count} entries"
     puts "1 - View all entries"
     puts "2 - View Entry Number n"
     puts "3 - Create an entry"
     puts "4 - Search for an entry"
     puts "5 - Import entries from a CSV"
     puts "6 - Nuke"
     puts "7 - Exit"
     print "Enter your selection: "

     selection = gets.to_i
     case selection
       when 1
         system "clear"
         view_all_entries
         main_menu
       when 2
         system "clear"
         view_entry
         main_menu
       when 3
         system "clear"
         create_entry
         main_menu
       when 4
         system "clear"
         search_entries
         main_menu
       when 5
         system "clear"
         read_csv
         main_menu
       when 6
         system "clear"
         nuke
         main_menu
       when 7
         puts "Good-bye!"
         exit(0)
       else
         system "clear"
         puts "Sorry, that is not a valid input"
         main_menu
     end
   end
 
   def nuke
      puts "Do you really want to remove all entries (Y/N)"
      selection=gets.chomp
      case selection.upcase
       when 'Y'
         address_book.entries.clear
         system "clear"
         main_menu
       when 'N'
         system "clear" 
         main_menu
       else
         system "clear"
         puts "Sorry, that is not a valid input"
         nuke
      end
   end
   
   def view_all_entries
      address_book.entries.each do |entry|
         system "clear"
         puts entry.to_s
         entry_submenu(entry)
      end
     
     system "clear"
     puts "End of entries"
   end
 
   def view_entry
      system "clear"
      if (address_book.entries.length == 0 )
         error_message( "No record available.  Please create at least one entry" )
         main_menu
      end
      print "Entry#: "
      entry = gets.chomp.to_i
      if (entry == 0) || ( entry > address_book.entries.length )
         error_message( "Record #{entry} does not exist" )
         view_entry
      else
         system "clear"
         puts address_book.entries[entry-1].to_s
         search_submenu(address_book.entries[entry-1])
      end
   end
   
   def error_message ( message )
      puts
      puts message
      puts
      puts "Press any key to continue"
      gets
      system "clear"
   end   
   
   def create_entry
     system "clear"
     puts "New AddressBloc Entry"
     print "Name: "
     name = gets.chomp
     print "Phone number: "
     phone = gets.chomp
     print "Email: "
     email = gets.chomp
     address_book.add_entry(name, phone, email)
     system "clear"
     puts "New entry created"
   end
 
   def search_entries
     print "Search by name: "
     name = gets.chomp
     # #10
     match = address_book.binary_search(name)
     system "clear"
     # #11
     if match
       puts match.to_s
       search_submenu(match)
     else
       puts "No match found for #{name}"
     end
   end
 
   def search_submenu(entry)
     # #12
     puts "\nd - delete entry"
     puts "e - edit this entry"
     puts "m - return to main menu"
     selection = gets.chomp
 
     case selection
       when "d"
         system "clear"
         delete_entry(entry)
         main_menu
       when "e"
         edit_entry(entry)
         system "clear"
         main_menu
       when "m"
         system "clear"
         main_menu
       else
         system "clear"
         puts "#{selection} is not a valid input"
         puts entry.to_s
         search_submenu(entry)
     end
   end
   
   def read_csv
     print "Enter CSV file to import: "
     file_name = gets.chomp
 
     if file_name.empty?
       system "clear"
       puts "No CSV file read"
       main_menu
     end
 
     begin
       entry_count = address_book.import_from_csv(file_name).count
       system "clear"
       puts "#{entry_count} new entries added from #{file_name}"
     rescue
       puts "#{file_name} is not a valid CSV file, please enter the name of a valid CSV file"
       read_csv
     end
   end
   
   def delete_entry(entry)
     address_book.entries.delete(entry)
     puts "#{entry.name} has been deleted"
   end
 
   def edit_entry(entry)
     print "Updated name: "
     name = gets.chomp
     print "Updated phone number: "
     phone_number = gets.chomp
     print "Updated email: "
     email = gets.chomp
     entry.name = name unless name.empty?
     entry.phone_number = phone_number unless phone_number.empty?
     entry.email = email unless email.empty?
     system "clear"
     puts "Updated entry:"
     puts entry
   end
 
   def entry_submenu(entry)
     puts "n - next entry"
     puts "d - delete entry"
     puts "e - edit this entry"
     puts "m - return to main menu"
 
     selection = gets.chomp
 
     case selection
       when "n"
       when "d"
         delete_entry(entry)
       when "e"
         edit_entry(entry)
         entry_submenu(entry)
       when "m"
         system "clear"
         main_menu
       else
         system "clear"
         puts "#{selection} is not a valid input"
         entry_submenu(entry)
     end
   end
end
 