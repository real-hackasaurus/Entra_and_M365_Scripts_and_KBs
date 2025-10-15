@echo off
REM **************************************************************************
REM Script Name: Export_Functions.cmd
REM Author: real-hackasaurus
REM Date: October 15, 2025
REM 
REM Description: This script exports saved functions from a Log Analytics
REM              workspace using Azure CLI commands. It performs the following:
REM              1. Logs in to Azure
REM              2. Sets the target subscription
REM              3. Exports saved functions to a JSON file
REM 
REM Prerequisites: Azure CLI must be installed and configured
REM **************************************************************************

REM 1. Login to Azure
az login

REM 2. Set the subscription
az account set --subscription "MySubscription"

REM 3. Export saved functions from Log Analytics workspace
az monitor log-analytics workspace saved-search list \
  --resource-group SentinelRG \
  --workspace-name MySentinelWorkspace \
  > saved_functions.json