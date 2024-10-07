##  Overview 🛠️

This script is designed to manage PostgreSQL databases. It provides options to create a new database, delete an existing database, and display help information. The script ensures proper user inputs and handles errors effectively.

![Screenshot from 2024-07-31 14-27-20](https://github.com/user-attachments/assets/cf8e7288-11fa-4b20-bea8-c0961399a848)



## Prerequisites 📋

-   **PostgreSQL**: Ensure PostgreSQL is installed and properly configured on your system.
-   **Privileges**: The script requires superuser privileges to execute database commands. It must be run with `sudo`.

## Features 🌟

-   **Create a New Database**: Prompts for database name, user, and password, then creates the database and user, and grants all privileges to the user.
-   **Delete an Existing Database**: Lists all non-template databases, allows selection of a database to delete, and confirms the deletion.
-   **Help**: Displays usage information.

## Usage 📚

### Running the Script 

To run the script, use the following command:

`sudo ./postgres_db_tool.sh ` 

### Script Options 

Upon running the script, you will be presented with a menu:

1.  **Create a New Database**:
    -   Prompts for the database name, user, and password.
    -   Creates the database, user, and grants privileges.
    -   Logs operations to `/tmp/db_script.log`.
2.  **Delete an Existing Database**:
    -   Lists all available databases.
    -   Prompts to select a database to delete.
    -   Confirms the deletion.
    -   Logs operations to `/tmp/db_script.log`.
3.  **Help**:
    -   Displays usage information and descriptions of the script's functionality.

### Example 💡

1.  **Create a New Database**:
    
    
    ```python
    Enter the database name: example_db
	Enter the database user: example_user
    Enter the database password: ******** 
    
2.  **Delete an Existing Database**:
    

    
    Fetching available databases...
    
    Available Databases:
    ```python 
    1. example_db
    2. test_db
    
    Enter the number of the database to delete: 1
    Are you sure you want to delete the database 'example_db'? (yes/no): yes` 
    

## Script Details


### Log File

-   The script logs messages and errors to `/tmp/db_script.log`.

### Functions

-   **display_separator**: Displays a separator line.
-   **log_message**: Logs messages to the console and the log file.
-   **create_database**: Handles database creation, user creation, and privilege granting.
-   **delete_database**: Lists databases, allows selection and deletion of a database.
-   **show_help**: Displays help information.
-   **check_permissions**: Ensures the script is run with superuser privileges.

### Error Handling

-   Errors are captured and logged to specific files:
    -   Database creation errors: `/tmp/db_create_error.log`
    -   User creation errors: `/tmp/db_user_error.log`
    -   Privilege granting errors: `/tmp/db_grant_error.log`
    -   Database deletion errors: `/tmp/db_delete_error.log`


----------

For any issues or contributions, please refer to the repository or contact [kibe](https://github.com/Laban254/postgres_db_tool/tree/main).
