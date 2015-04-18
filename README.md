XSDConverter
=========

Parses XSD files and generates Objective-C classes for IOS (or OSX) -- uses libxml only

For every Complex Type in your schema file, a corresponding Objective-C class is generated with its attributes and elements as Objective-C properties and an init method taking an libxml2 TextReader is generated.

The code is generated according to a template that you can easily customize if you need to generate specific/exotic code. For most folks the standard template included should work just fine.

The generator is a framework that is completely seperate from the GUI. And thus it can be embedded in any cocoa app.

**The generator is checked which unit tests that read specific xsds, generate code for it, compile it using clang and then see if they can parse an according xml**<br/>
(so IF you find bugs / missing features - please provide a xsd & a xml file so I can fix it / add it to the generator)

###What works already: (1.4)
##### (the key points I remember)

- Complex type elements
- Simple type elements/attributes (standard and custom)
	- **40/44 types defined by the w3c work**<br/> 
	outstanding: date, time, base64Binary, hexBinary
- Inheritance by extension
- restrictions with enumeration support (thanks to Alex Smith for the initial trigger) ** 1.4 **
- Static parsing methods for global elements (a category is generated for a complex type that is used as the root element)
- Mapping xml namespaces to class name prefixes via a specific tag in a template. (without it, namespaces are mapped 1 : 1 to Class prefixes)
- referencing external files to copy to the destination folder when generating code ** 1.2 **
- nested sequences & choices
- includes and imports of other XSD files ** 1.3 **
- annotations of elements that are converted to comments ** 1.3 **
- anonymous 'inner' types (complex and simple)

the **generated parser** only requires libxml and I have tested it on **IOS as well as OSX**
- **(Remember: to use the classes, link your target against libxml2 (!))**

The generator itself uses the NSXML* tree based API and is for OSX only.

###Biggest pain points
1. So far the generator does NOT handle references to elements/attributes via the ref= attribute.
2. The min & maxOccurances of elements inside a sequence/choice must be specified on element itself as opposed to the sequence itself

---

The Project is still in alpha phase, BUT real world usage is already be possible. *and practiced* <br/>
**A demo project is included** and I used it to generate XML Parsers for **two commercial projects already** (Ill merge back fixes as I find the time).

###how-to (based on 1.0)
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

###credits
The basic code was on google projects. **The original xsd2cocoa was written by Stefan Winter** in 2011 and even if not really usable, it was **already quite awesome**

I made numerous fixes and improvements to the generator.
- additions to properly deal with lots of more XSD features (too many to list here)
- new features to the template to make things more customizable
- a lot of refactoring. Modernizing, getting rid of code... I would say I removed 1/2 the code ;)
- addded a UI for the app as well as a Demo project to make it easier to use
- modernized and completed the templates used to generate the code

The code uses the MGTemplateEngine by Matt Gemmel