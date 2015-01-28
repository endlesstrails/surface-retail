
# Surface Retail EDI Processes 
### v3.0
@author jamesjreynolds@gmail.com

This process converts a properly formatted input file to the KWI-VOLCOM-ARTICLE-yyMMdd-HHmmSS.TXT format.
It performs two different sets of logic depending on the specified company parameter
It uses POSIX standard programming tools (mostly awk) and is platform independent.

### Release Notes

Minor enhancement to field 5 calculations.
- All EV## Convert to ES
- All EY## Convert to ES

### Usage

Run the run.sh script in the root directory and pass it the input file as the sole parameter on the command line.
Once you've expanded the zip file, the directory can be installed anywhere you like.
To use the program, you'll first want to navigate to the location of the expanded surface_retail directory.  From the Cygwin terminal prompt, type the following:

```bash
cd /cygdrive/c/path/to/surface_retail_v2
```

From there, you can run the file.  The parameter that you pass to the file is the location of the input file.  For simplicity's sake, you can copy the input file inside the surface_retail directory.  Then you'll run the command like this:

```bash
./run.sh -f inputFileName.txt -c volcom
```

 Options: | |
 -|-|-
   | -f | --file	|		Pass the input file as an argument on the command line.
   | -c | --company |		Pass the company name for which this file will be prepared (volcom|electric).
   | -t | --transfer |		Pass -t or --transfer as an additional argument to transfer the file via ftp.
   | -o | --output |		Pass -o or --output to print the results to the console instead of the output file (for debugging purposes).

When processing is complete, it will place the output file in the root Surface_Retail_v2 Directory.

### Requirements:

In the Windows environment, a Bash emulator, like Cygwin (http://cygwin.com/index.html), must be used to run the program.  Make sure the Awk packages are installed in the setup process.
This process will run natively in a Unix/Linux/Mac environment, though the file permissions will likely need to be changed after the files are copied to the host machine.  Set the execute bit for the run.sh file in the root folder and all script files in the bin folder.
