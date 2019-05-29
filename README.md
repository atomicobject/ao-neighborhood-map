# Instructions for Running

1. The neighborhood data should be in the same directory with the name "gr_neighborhoods.txt".

2. The test data points should be in the same directory with the name "test_data.txt".

3. Run the "find-neighborhoods" executable from the terminal (make sure it has permission).
	`> ./find-neighborhoods`

4. The results are printed to the terminal as well as collected in an "output.txt" file in the same directory.

# Instructions for Compiling and Testing

1. Install "sfont" package.
	`> raco pkg install sfont`

2. Install "threading" package.
	`> raco pkg install threading`

3. Install "rack unit" package.
	`> raco pkg install rackunit-lib`

4. Tests can be run in the terminal. I didn't write a full test-suite, but added some tests to the submodules.
	`> raco test modules/neighborhood.rkt`
	`> raco test modules/vertex.rkt`