@echo off
setlocal

REM Define variables
set "MONGODB_URL=https://fastdl.mongodb.org/windows/mongodb-windows-x86_64-7.0.12-signed.msi"
set "MONGODB_MSI=mongodb-windows-x86_64-7.0.12-signed.msi"
set "NODEJS_URL=https://nodejs.org/dist/v20.16.0/node-v20.16.0-x86.msi"
set "NODEJS_MSI=node-v20.16.0-x86.msi"
set "PYTHON_URL=https://www.python.org/ftp/python/3.12.4/python-3.12.4-amd64.exe"
set "PYTHON_EXE=python-3.12.4-amd64.exe"
set "TEMP_DIR=%TEMP%\install_temp"

REM Create a temporary directory
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
cd /d "%TEMP_DIR%"

REM Ask whether to skip MongoDB installation
set /p SKIP_MONGO=Do you want to install MongoDB? [y/N]: 
if /i "%SKIP_MONGO%"=="y" (
    REM Download MongoDB MSI using curl for faster download
    echo Downloading MongoDB...
    curl -o %MONGODB_MSI% %MONGODB_URL%

    REM Install MongoDB
    echo Installing MongoDB...
    msiexec /i "%MONGODB_MSI%" /qn /norestart

    REM Clean up
    echo Cleaning up...
    del "%MONGODB_MSI%"

    echo MongoDB installation completed.
) else (
    echo Skipping MongoDB installation.
)

REM Ask whether to install Node.js
set /p INSTALL_NODE=Do you want to install Node.js? [y/N]: 
if /i "%INSTALL_NODE%"=="y" (
    REM Download Node.js MSI using curl
    echo Downloading Node.js...
    curl -o %NODEJS_MSI% %NODEJS_URL%

    REM Install Node.js
    echo Installing Node.js...
    msiexec /i "%NODEJS_MSI%" /qn /norestart

    REM Clean up
    echo Cleaning up...
    del "%NODEJS_MSI%"

    echo Node.js installation completed.

    REM Verify installation
    node -v
) else (
    echo Skipping Node.js installation.
)

REM Ask whether to install Python
set /p INSTALL_PYTHON=Do you want to install Python? [y/N]: 
if /i "%INSTALL_PYTHON%"=="y" (
    REM Download Python installer using curl
    echo Downloading Python...
    curl -o %PYTHON_EXE% %PYTHON_URL%

    REM Install Python
    echo Installing Python...
    %PYTHON_EXE% InstallAllUsers=1 PrependPath=1 Include_test=0

    REM Clean up
    echo Cleaning up...
    del "%PYTHON_EXE%"

    echo Python installation completed.

    REM Verify installation
    python --version
) else (
    echo Skipping Python installation.
)

REM Installing other needed packages
echo Installing git and make
winget install -e --id Git.Git
winget install -e --id ezwinports.make
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
