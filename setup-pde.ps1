# Setup personal development environment in Windows

Function Test-CommandExists
{
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try {if(Get-Command $command){RETURN $true}}
    Catch {Write-Host "$command does not exist"; RETURN $false}
    Finally {$ErrorActionPreference=$oldPreference}
} #end function test-CommandExists

Function Reload-Path
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

if (!(Test-CommandExists choco))
{
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
& choco --version

if (!(Test-CommandExists git))
{
    choco install -y git
    Reload-Path
}
& git --version

if (!(Test-CommandExists nvim))
{
    choco install -y neovim FiraCode
    Reload-Path
}
& nvim --version

if (!(Test-Path -Path $HOME/AppData/Local/nvim/init.lua -PathType Leaf))
{
    git clone https://github.com/sakhnik/dotfiles $HOME/dotfiles
    New-Item -Type Symboliclink -Target $HOME/dotfiles/src/.config/nvim -Path $HOME/AppData/Local/nvim
}

if (!(Test-CommandExists msys2))
{
    choco install -y msys2
    Reload-Path
    # TODO: update msys2.ini
}

if (!(Test-CommandExists gcc))
{
    c:\tools\msys64\usr\bin\bash -l -c "pacman --noconfirm -Syu"
    c:\tools\msys64\usr\bin\bash -l -c "pacman --noconfirm -S mingw-w64-x86_64-gcc"
    $local:rpath = 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' 
    $local:path = (Get-ItemProperty -Path $local:rpath -Name path).path
    $local:path  =  "$local:path;c:\tools\msys64\mingw64\bin"
    Set-ItemProperty -Path $local:rpath -Name path -Value $local:path
    Reload-Path
}
gcc --version

if (!(Test-CommandExists rg))
{
    choco install -y ripgrep
}
& rg --version
