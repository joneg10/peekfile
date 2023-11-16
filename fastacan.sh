# MIDTERM ASSIGNMENT
## Prepare the optional arguments
directory=$2 # Folder
N=$3 # Number of lines

## Define the default arguments.
if [[ -z $directory ]]; then directory='.'; fi
if [[ -z $N ]]; then N=0; fi

## How many files.


## How many unique fasta IDs.


## Files:


### Header: filename, symlink?, sequences, total seq length (no gaps), extra: aa/nt seq?


### Content: If fine <= 2N; full cont, if not N head, ... and N tail. If 0 skip.


