//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mike Beatty
// Date and time: 10/29/21, 12:37:16
// ----------------------------------------------------
// Method: ___Notes
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

//Repository tables stores:
//name
//DOB
//DOD
//sex
//human_index

//tables organized by Country Code, followed by letter code referencing cutoff (last letter)

//some methods referencing Countries table/datastore, but there is no table in structure
//some methods referencing Name_Impurities table/datastore, but there is no table in structure


//standardizing file formats
//standardizing name formats -- create name object in import/repository?
//storage in object, queries can QBA, what is effect on speed?
//force headers -- each column has a title that matches expected structure
//routine evaluates headers, determines if we proceed or not

//start to compile some stats on speed of processing each stage
//Import - L2, cleanup, move to Records
//Repositiory - query, then import
//what do we finalize query on? will need indexed fields in each table
//do we have same indexed fields in Import?

//note -- could not modify Import structure, had to modify catalog

//add field for file tracking?
//sufixes and prefixes should be removed
//as we identify formats, such as FML construct, save as an import template
//create/store templates in background to capture name structures
//certainty calculation based on source document - official/non-official/casual(informal)

//begin development of simple web interface for queries


//need standardized column headers
//FirstMiddleLast
//firstMiddle
//Last, First Middle
//sex
//dateofbirth
//birth day
//birth month
//birth year
//dateofdeath
//death day
//death month
//death year

//when files are submitted, send w/out header, have header as accompanying file
//myFile.txt, myFile.header

//of all the files we have now, what are the existing formats?



//review Trello, get caught back up
//start to create tickets for import formats


//121321
//background stores info as provided by forebears
//import goes uppercase
//repo goes uppercase
// uppercase

//revist fields - skop individual has
//add name object for more flexibility

//Mike to work on list of additional needs for fields, preprocessing, etc.
//what is necessary vs what are enhancements, nice to have.
//what is the timing on getting Madagascar up to speed on new columns -- we don't need to work now, but will be helpful down the road.
//list for repository
//list for import
//move into Trello, review existing list


//// Modified by: Mike Beatty (12/17/21)
//agenda

//1 - discuss standard file formats
//naming conventions
//minimum data requirements

//2 - discuss field format in REPO
//name fields -- organize by country/ethnicity? use a name object? or just create 10 fields for name
//what other fields do we want to capture -- everything else on form?
//what should be hashed? depends on search -- query individual field, clear seems faster
//hash first and last?
//going with 4 name fields?


//purpose for names
//do you have this name for iport
//do you have this name for query?
//do you have this name for display

//will rebuild human, using either western or hispanic naming structures
//will only have 50+/- tables, will be provided by AB, stored in BackgroundCountries


//store index value in repositiory
//should be calculated in Import to determine if record should be send to/included in repository

//next steps:
//revise repository structure for western/jispanic
//AB to provide list of countires
//review headers for data files -- AB to review, send to MDG
//review current hash fields -- what is relevant/useful

//focus on western at this time/USA, simply to get things working
//add object to capture names in richer format in the event we need to go back and extract info

//what do we need from import for repository?









