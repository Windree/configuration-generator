
# A docker container to generate configuration based on jinja2 templated

# Prepare
1. Create the data folder
1. Copy files from the data.example folder to the data folder

## Usage
[--format &lt;type&gt;] [--on-start &lt;command&gt;] [--on-completed &lt;command&gt;] [--on-error &lt;command&gt;] [--on-empty &lt;command&gt;] [--on-changed &lt;command&gt;] [--on-exit &lt;command&gt;] [--watch &lt;location&gt;]... [--data-file &lt;data file&gt;]... &lt;template&gt; &lt;output file&gt;

## Command line arguments
* &lt;template&gt; - path to template file
* &lt;data file&gt; - paths to data file
* &lt;output file&gt; - path to output file

* &minus;&minus;watch=/data/data/ - Watches specific files or directories for changes and regenerates the output configuration when changes occur. If you do not use the --watch option, the container exits after generating the configuration once
* &minus;&minus;format=type - Format of input file json, yaml, csv
* &minus;&minus;on-start=command - Command to run on start
* &minus;&minus;on-completed=command - Command to run on successfully completed
* &minus;&minus;on-error=command - Command to run on error
* &minus;&minus;on-empty=command - Command to run if data files for configuration disappeared
* &minus;&minus;on-changed=command - Command to run on change in &lt;watch=&gt; location(s)
* &minus;&minus;on-exit=command - Command to run on exit the program

## Example
docker build image -t cg && docker run --rm -it  -v `pwd`/data:/data cg \
    --data-file=/data/data/data.json \
    --data-file=/data/data/files.json \
    /data/template.j2 /data/output/output.conf \
    --watch=/data/data \
    --on-start='echo configuration generation started' \
    --on-completed='echo configuration generated successfully && touch /data/healthcheck' \
    --on-error='rm -f /data/healthcheck' \
    --on-empty='rm -f /data/healthcheck' \
    --on-changed='echo regenerating configuration' \
    --on-exit='echo Exiting && rm -f /data/healthcheck'
