#!/bin/bash
@echo off
echo This script will start the Ubuntu full update process
echo Are you sure you want to continue?

CHOICE /C YN /M "Press Y for Yes, N for No: "

IF %ERRORLEVEL% EQU 1 (
    apt-get update
    apt-get upgrade -y
    apt-get full-upgrade -y
    apt-get autoremove -y
    apt-get autoclean -y
) ELSE (
    echo You chose No. Aborting...
    exit /b
)
