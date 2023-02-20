#!/usr/bin/bash 
#              ___.                                           
#  ____ ___.__.\_ |__   ___________  ____  __ _________ __ __ 
#_/ ___<   |  | | __ \_/ __ \_  __ \/ ___\|  |  \_  __ \  |  \
#\  \___\___  | | \_\ \  ___/|  | \/ /_/  >  |  /|  | \/  |  /
# \___  > ____| |___  /\___  >__|  \___  /|____/ |__|  |____/ 
#     \/\/          \/     \/     /_____/                     


# Display contents of the script for a user to choose functionality

# Display the management menu
function menu () {
	clear
	echo "UMS management script"
	echo ""
	echo "A) User Management"
	echo "B) File management"
	echo "C) Pipe interprocess"
	echo "Q) Quit"
	echo ""
	echo "Enter the letter for the option you want to pick: "
	read user_input
	
	while getopt ABCQ user_input ; do
		
		case $user_input in
					
		A|a)	# Calling the user management menu
			User_menu
			# Calling the menu function after the user exits
			menu
			;;
			
		B|b)	# calling the file menu function.
			file_Menu
			
			# Calling the menu function after the user exits
			menu
			;;
			
		C|c) 	# calling the pipe menu
			pipe_menu
			# Calling the menu function after the user exits
			menu
			;;
			
		Q|q)	# Stop running the script.
			echo "exiting..."
			exit 1
			;;
			
		*)	# Option not valid

			echo "Error: Please select a valid option from the list."
			echo ""
			menu
			;;
		esac
	done
}



# A script that performs user management such as:
#	* User creation and deletion
#	* User group creation, with option to assign a user to a group
#	* Creating a user directory


# Display the management menu
function User_menu () {
	clear
	echo "User management script"
	echo ""
	echo "A) Create a user account"
	echo "B) Delete a user account"
	echo "C) Manage user groups   "
	echo "D) List Users           "
	echo "Q) Quit"
	echo ""
	echo "Enter the letter for the option you want to pick: "
	read user_input
	
	while getopt ABCQ user_input ; do
		
		case $user_input in
		
		A|a)	# Run the change user function.
			createUser
			
			# Calling the menu function after the user exits
			User_menu
			;;
			
		B|b)	# Run the delete user function.
			deleteUser
			
			# Calling the menu function after the user exits
			User_menu
			;;
			
		C|c) 	# Run the create user group function.
			manageGroup
			
			# Calling the menu function after the user exits
			User_menu
			;;
		D|d)    # List the information of users on the system
			cat /etc/passwd | awk -F: '{print  "User:  " $1 "    " "UID: " $3 "    ""GID: " $4}'
			echo " "
			echo "Press enter to continue "
			read
			clear
			# Calling the menu function after the user exits
			User_menu
			;;
			
		Q|q)	# Stop running the script.
			echo " "
			clear
			menu
			;;
			
		*)	# Option not valid
			clear
			echo "Error: Please select a valid option from the list."
			echo ""
			exit 1
			;;
		esac
	done
}

#Create a user interface and functionality.
function createUser() { 
	clear
	echo "Creating A User Setup"
	echo ""
	read  -p 'Firstname: ' firstname
	read  -p 'Lastname: ' lastname
	user_name=${firstname:0:1}${lastname/ /}
	echo ""
	read -p "Please enter the users home directory name: " home_directory
	echo ""
	read -p "Enter user password: " pass
	
	# creating the user account with the useradd function 
	sudo useradd -d $home_directory -p $(mkpasswd --hash=SHA-512 SandBoxie) -c $pass $user_name

	echo "The user account has been created. Press any key to continue."
	read
	clear
}

function deleteUser() {
	clear
	echo "Delete A User Setup"
	echo ""
	echo -n "Please enter the username you would like to delete: "
	read username

	echo -n "Do you want to delete the home directory of user $username? (y/n)"
	read choice

	if [ $choice == "y" ] || [ $choice == "Y" ]
	then	
		echo "Deleting user"
		sudo userdel -r $username
	else
		sudo userdel $username
	fi

	echo "The user has been deleted. Press any key to continue."
	read
	clear
}

function manageGroup() {
	clear
	echo " Managing User Groups "
	echo ""
	echo "A) Create a user group"
	echo "B) Delete a user group"
	echo "C) Assign user to a group"
	echo "Q) Quit"
	read choice
	while getopt "ABQC" in choice; do

		case $choice in
	
		A|a)	# collecting user group details
			echo "Creating A User Group"
			echo ""
			read -p "Enter User Group Name: " userGroup
			echo ""
			# checking if the user group exists 
			if grep -q $userGroup /etc/group
   			then
   				echo "The User Group already exist"
			else
				sudo groupadd $userGroup
				echo ""
				echo "$userGroup has been created. press any key to continue."
			fi
			echo "Press Enter to continue "
			read
			clear
			manageGroup
			;;
			
		B|b)	#deleting a user group
			echo ""
			echo "Enter User Group Name to Delete"
			read userGroup
			echo ""
			# checking if the user group exists
			if ! grep -q $userGroup /etc/group
   			then
   				echo "The User Group does not exist"
			else
				sudo groupdel $userGroup
				echo ""
				echo "$userGroup has been deleted. press any key to continue."
			fi
			echo "Press Enter to continue "
			read
			clear
			manageGroup
			;;
			
			
		C|c)	#Assigning a user to a group
			echo "Assigning a user to a group"
			echo "Enter User Group Name: "
			read userGroup
			echo ""
			read -p "Enter User name: " user_name
			# checking if the user group exists
			if ! grep -q $userGroup /etc/group
   			then
   				echo "The User Group does not exist"
			else
				sudo usermod -a -G $userGroup $user_name
				echo "The user $user_name has been assigned to $userGroup group. press any key to continue."
			fi
			echo "Press Enter to continue "
			read
			clear
			manageGroup
			;;
			
		Q|q)	# exit function
			echo "exiting..."
			User_menu
			;;
			
		*)	# If the option inputed is invalid
			clear
			echo "Error: Please select a valid option from the list."
			echo ""
			manageGroup
			;;
		esac
	done
}



# FILE MANAGEMENT SCRIPT
#Script to perform file managent on a system such as:
# * Re-organizing files into a directory
# * File system information
# * Find files accordint to user input

## File_menu



file_Menu(){
	# function to re-Organize user files according to extension
	clear
	echo "Enter the following options to perform file management"
	echo "A) change file prefix in a directory"
	echo "B) Re-Orgainze files according to file extension "
	echo "C) Find a file or directory "
	echo "Q) Quit"
	read choice
	
	while getopt "AB" in $choice; do
	
		case $choice in
		
		A|a) # change file prefix in a specific directory
			echo " "
			echo "Enter path to directory "
			echo "Example /home/user/directoryName "
			read userPath
			echo "Enter prefix to replace with"
			read userPrefix
			
			# check if the entered path exists
			if [ ! -e $userPath ]
			then
				echo "  "
				echo "Path to directory does not exist "
				echo "Please enter a correct path !!!  "
				break
			fi
			
			# storing the contents of the directory in a variable
			contents=$(ls $userPath)

			# change to path
			cd $userPath
			
			# looping through the files and changing the file prefix each at a time
			for names in $contents
			do
				# changing the file names
				mv $names  ${userPrefix}_${names}
			done
			
			echo "File prefix names have been changed succesfully !! "
			echo "   - - - - changed files - - - - - - - - "
			echo " "
			ls $userPath
			echo "Press Enter to continue "
			read
			clear
			file_Menu
			;;
		
		B|b) #  Re-Orgainzing files according to file extension
			echo " "
			echo "Enter path to directory "
			echo "Example /home/user/directoryName "
			read dirPath
			
			# check if the entered path exists
			
			if [ ! -e $dirPath ]
			then
				echo "  "
				echo "Path to directory does not exist "
				echo "Please enter a valid path !!!  "
				continue
			fi
			
			contents=$(ls $dirPath)
			
			for file in $contents
			do
				# glob the file extension
				fileExtension=${file##*.}
				
				# use the globbed file extension to make a directory name
				fileExtensionDir=${fileExtension}_dir
				
				# check if the file extension is a directory or a file
				# continue if it is
				if [[ -d $fileExtension  ]] || [[ -f $fileExtension ]]
				then
					continue
				
				# check if the file extension dir exists
				# creates one if it isn't
				elif [ ! -e $fileExtensionDir ]
				then
					mkdir $fileExtensionDir
					
				fi
				
				# then finally move the file to the extension dir
				mv $file  $fileExtensionDir
				
				
			done
			
			echo "Files moved succesfully !! "
			echo "  "
			echo "Press enter to continue   "
			read
			
			file_Menu
			;;
			
		C|c)	# function to find a directory or a file in the system
			echo "Enter file or Directory name to find: "
			read inputParam
			
			# using the find function to find a file in the system path
			find /  -name ${inputParam} 2>/dev/null
			
			echo " "
			echo "Press Enter to continue "
			read
			clear
			file_Menu
			;;
			
		Q|q)	# Stop running the script.
			echo " "
			clear
			# go back to main menu
			menu
			;;
			
			
		*)	# If the option inputed is invalid
			echo "Error: Please select a valid option from the list."
			echo ""
			file_Menu
			;;
		esac
		
	done
}		

# Pipes and interprocess communications
# This script uses a named pipe to write to a file 
# in another directory
#

function pipe_menu(){

	# function that uses a name pipe to write to a pipe
	clear
	echo "Enter the following options to modify a file using pipe"
	echo "A) Write to a file using pipe "
	echo "D) Use demo mode to write lorem ipsum "
	echo "Q) To exit "
	
	read response
	
	while getopt "AD" in $response; do
	
		case $response in
	
		A|a)	# write to a file using pipe
			echo "Enter file name to write to"
			read fileName
			
			echo "Enter text to write to file"
			read text
			
			# calling the wirte to pipe functions
			write_pipe "\${text}" 
			
			# calling the read from pipe function to write to file
			read_pipe $fileName
			
			echo "Text written to file succesfully !! "
			echo " "
			echo "Press enter to continue "
			read
			pipe_menu
			;;
			
		D|d)	# using demo mode
			# Writing  lorem ipsum into the input file
			
			# Using a tmp file
			testfile="/tmp/testfile"
			
			lorem_ipsum="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam sedvehiculaurna."
			
			write_pipe "\${lorem_ipsum}"
			read_pipe $testfile
			echo "Text written to file succesfully !! "
			echo " "
			echo "Press enter to continue "
			read
			pipe_menu
			;;
			
		Q|q)	# Stop running the script.
			echo " "
			clear
			menu
			;;
			
			
		*)	# If the option inputed is invalid
			echo "Error: Please select a valid option from the list."
			echo ""
			pipe_menu
			;;
		esac
		
	done
}

function write_pipe(){

	# function to write to a named pipe

	# uses the tmp directory to create a test pipe
	testpipe="/tmp/testPipe"
	
	# using a trap statement to remove pipe when done
	
	trap "rm -f $testpipe" EXIT
	# condition to check if the pipe exists
	# else it creates it
	if [[ ! -p $testpipe ]]; then
	
		mkfifo $testpipe
	fi
	
	eval text="$1" # convert input to a string of sentence
	
	# writes user input into the named pipe and send the process to background
	echo "$text" > $testpipe &
	
}

function read_pipe(){
	# function to read form the creatd named pipe
	
	testpipe="/tmp/testPipe"
	
	# use a while loop to read from the pipe and
	# write to the file passed through arg

	
	while read line <$testpipe
	do	
		#send the content of the pipe into a file 
		echo $line >> $1
	done

}

menu
