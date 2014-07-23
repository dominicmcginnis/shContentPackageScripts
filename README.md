This is a tool for creating Stubhub content bundles for use on the gen3 stack.  

The script can be exectued to pull the original source from production, to package up the bundles or do both in succession.  A typical use case would be to use the script to pulldwon the original source, manually make changes to the source, use the script to create the bundle package and manually upload both source and bundle.

An example to build the home page CSS bundle is as follows:
1.  ./packagePromotions.sh css_home pull
2.  Alter src/www-5.4.css
3.  ./packagePromotions.sh css_home package
4.  Upload altered source (src/www-5.4.css)
5.  Upload bundle (target/home-content-bundle.min.css)

To create a new bundle for support do the following:
	1.  Add a new text file under fileLists with a .txt extention that lists the set of files to be included in the bundle (they should be listed in the expected inclusion order)
	2.  Alter the packagePromotions.sh script to add a new "TYPE"
		a) Change the die statement to include the new Available type
		b) Alter the main case statement at the bottom of the script to contain the new TYPE 
 
