#!/bin/bash


powershell.exe "Start-Process powershell.exe -Verb RunAs -Args '-executionpolicy bypass -command', 'Set-Location ${PS_SCRIPT_PATH}; .\wsl_scheduled_task.ps1'" 
