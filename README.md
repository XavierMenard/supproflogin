# Supprof Connection Program

This PowerShell script provides a login interface for the Supprof program. It allows users to connect to a system using a 7-digit code and select a "plateau" (Software, Hardware, or Network) for further actions. The scripts are executed with administrative privileges, ensuring that users can perform necessary tasks without additional permissions issues.

## Features

- **Login Interface**: A graphical login form that validates a 7-digit code.
- **Admin Privileges**: All actions are executed with administrative rights.
- **Plateau Selection**: Once logged in, the user can select a "plateau" (Software, Hardware, Network), each triggering its corresponding script.
- **Customizable Scripts**: The program is designed to execute different PowerShell scripts based on the user's selection.

## Requirements

- PowerShell 5.1 or higher (for Windows)
- Administrative privileges are required for the script to function properly.
- `System.Windows.Forms` library for graphical user interface.

## Setup

1. Clone the repository to your local machine.
2. Ensure that the PowerShell scripts (`SupprofLogiciel.ps1`, `SupprofMateriel.ps1`, `SupprofReseau.ps1`) are placed in the same directory as the main script (`login.ps1`).
3. Modify the script names as needed to match the actual scripts used for each "plateau".
4. Run `login.ps1` to start the program.

## Usage

1. **Start the Program**: Run the `login.ps1` script using PowerShell.
2. **Enter the Login Code**: The program will prompt you to enter a 7-digit code. If the code is valid, you will be able to proceed.
3. **Select a Plateau**: Once logged in, select one of the available plateaus (Software, Hardware, or Network). This will trigger the corresponding script.
4. **Admin Privileges**: The selected script will run with administrative privileges.

## Example

```powershell
.\login.ps1
