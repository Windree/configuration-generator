
# A docker container to generate configuration based on jinja2 template when a source file/directory changed

# Prepare
1. Create the data folder
1. Copy files from the data.example folder to the data folder

## Usage
[&minus;&minus;watch \<location\>]... [&minus;&minus;format \<type\>] \<template\> \<input file\> \<output file\>

## Command line arguments
* &minus;&minus;watch /data/ - watch for specific files or directories for changes and recreate output configuration on changes. The container exits after generate configuration if no --watch options specified
* &minus;&minus;format type - format of input file json, yaml, csv
* template - path to template file
* input file - path to data file
* output file - path to output file
