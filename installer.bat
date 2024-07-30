@echo off
setlocal

REM Define variables
set "MONGODB_URL=https://fastdl.mongodb.org/windows/mongodb-windows-x86_64-7.0.12-signed.msi"
set "MONGODB_MSI=mongodb-windows-x86_64-7.0.12-signed.msi"
set "TEMP_DIR=%TEMP%\mongodb_install"

REM Ask whether to skip MongoDB installation
set /p SKIP_INSTALL=Do you want to skip MongoDB installation? [y/N]: 
if /i "%SKIP_INSTALL%"=="y" (
    echo Skipping MongoDB installation.
) else (
    REM Create a temporary directory
    if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
    cd /d "%TEMP_DIR%"

    REM Download MongoDB MSI using curl for faster download
    echo Downloading MongoDB...
    curl -o %MONGODB_MSI% %MONGODB_URL%

    REM Install MongoDB
    echo Installing MongoDB...
    msiexec /i "%MONGODB_MSI%" /qn /norestart

    REM Clean up
    echo Cleaning up...
    del "%MONGODB_MSI%"

    REM Return to the calling directory
    cd /d %~dp0
    echo MongoDB installation completed.
)

REM Installing other needed packages
echo Installing choco, git, make, fnm, and Python
winget install -e --id Chocolatey.Chocolatey
winget install -e --id Git.Git
winget install -e --id ezwinports.make
winget install -e --id Python.Python.3.12
winget install -e --id Schniz.fnm
echo Installation completed.

echo Install current Node
fnm use --install-if-missing 20
echo Installation completed.

echo Upgrade pip
py -m pip install --upgrade pip
echo Installation completed.

echo Cloning backend repository...
git clone https://github.com/MiddleSchoolMathGuide/backend
cd backend
echo Done.

echo Setting up backend submodules...
git submodule update --init --recursive
echo Done.

echo Running make install
make install
echo Done.

echo Running make build
make build
echo Done.

echo All installations and setups are completed.

REM Return to the original directory and exit
cd /d %~dp0
endlocal
exit /b
