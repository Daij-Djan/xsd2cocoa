xsd2cocoa
=========

Parses XSD files and generates Objective-C classes for IOS (or OSX) -- uses libxml only

For every Complex Type in your schema file, a corresponding Objective-C class is generated with its attributes and elements as Objective-C properties and an init method taking an libxml2 TextReader is generated.

The code is generated according to a template that you can easily customize if you need to generate specific/exotic code. For most folks the standard template included should work just fine

Following standard simple types are currently supported:

<table>
<tr><td><b>XSD Type</b></td><td><b>Cocoa Type</b></td></tr>
<tr><td>string</td><td>NSString</td></tr>
<tr><td>int</td><td>NSNumber</td></tr>
<tr><td>integer</td><td>NSNumber</td></tr>
<tr><td>decimal</td><td>NSNumber</td></tr>
<tr><td>boolean</td><td>NSNumber</td></tr>
<tr><td>dateTime</td><td>NSDate</td></tr>
<tr><td>anyURI</td><td>NSURL</td></tr>
</table>

The Project is still in alpha phase, BUT real world usage  is already be possible. <br/>
**A demo project is included** and I used it to generate XML Parsers for **two commercial projects already**.

###how-to
##### (very brief ;))
1. download the sourcecode and use XCode 5+ to build the xsd2cocoa mac app. (At this point, Im not providing a binary)
2. Upon starting the app you see a window 
![1](https://raw.github.com/Daij-Djan/xsd2cocoa/master/README-files/1.png)

3. here you specify:
	- the XSD to process
	- the output folder for the generated .m/.h files
	- the template to use (built-in vs. custom path)
![2](https://raw.github.com/Daij-Djan/xsd2cocoa/master/README-files/2.png)

3. After specifying the in- and output paths you hit 'write code' and you get ready to use .h/.m files. **(Remember: to use the classes, link against libxml2 (!))**
![3](https://raw.github.com/Daij-Djan/xsd2cocoa/master/README-files/3.png)

###What works already:
##### (the key points I remember)

-Complex type elements (except local anonymous complex types)
- Simple type elements/attributes (standard and custom)
- Sequences and choices (but no nesting of the groups)
Inheritance by extension
Static parsing methods for global elements (a category is generated for a complex type that is used the root element)
- Mapping xml namespaces to class name prefixes via a specific tag in a template. (without it, namespaces are mapped 1 : 1 to Class prefixes)
- referencing external files to copy to the destination folder when generating code

the **generated parser** only requires libxml and I have tested it on **IOS as well as OSX**
- **(Remember: to use the classes, link your target against libxml2 (!))**

The generator itself uses the NSXML* tree based API and is for OSX only.

###Filterable arrays
In the screenshot above I show you that the app has 2 built-in objective C templates. One that uses NSArrays for collections of objects, one that uses DDFilterableArrays...

#####So ... why? Because of convenience! :D
DDFilterableArrays allow you to use the modern objC brackets to filter the Array.

so instead of:

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"color.name BEGINSWITH 'b'"];
	NSArray *subArray = [myArray filteredArrayUsingPredicate:predicate];

you just write:

	DDFilterableArray *subArray = myArray[@"color.name BEGINSWITH 'b'"];
	
this is very nice for parsing especially combined with KVC. e.g.:

	myBooks = [rootElement valueForKeyPath:@"stores.books"][@"owned=YES"]

###credits
##### (the key points I remember)
The basic code was on google projects. **The original xsd2cocoa was written by Stefan Winter** in 2011 and even if not really usable, it was **already quite awesome**

I made numerous fixes and improvements to the generator.
- additions to properly deal with lots of more XSD features (too many to list here)
- new features to the template to make things more customizable
- a lot of refactoring. Modernizing, getting rid of code... I would say I removed 1/2 the code ;)
- addded a UI for the app as well as a Demo project to make it easier to use
- modernized and completed the templates used to generate the code

The code uses the MGTemplateEngine by Matt Gemmel