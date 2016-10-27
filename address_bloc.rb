require_relative 'controllers/menu_controller'
 
 menu = MenuController.new
 system "clear"   # Clear the command line
 puts "Welcome to AddressBloc!"
 menu.main_menu 
