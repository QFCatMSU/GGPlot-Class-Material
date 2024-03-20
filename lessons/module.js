/*
- JS: onload check for homePAge before 
- CSS: p,h2,h3,h4 -> margin 0 -> important
- CSS: take away negative text-indent for p>code and span>code within a table 
- To DO: Remove Previous/Next Page from JS/CSS
-        Fix sizing on H2,3,4
*/
/*
Future:
-- 2023 --
- Put flexsize width/height in JSON (or, manage without global variable)

- turn off longclick timer on horizontal scroll in widget
- Deal with situation with figures are not siblinged to a block object
- look for Span with class and title inside <p>
  - but not everything becasue you could have a span at the beginning of a line...
- fix wayward div in page (there should not be a div in the editor -- it is copied/pasted in)
- multi-line equations stay on one line in MathJax (will MathJax fix?)
- use encapObject whenever possible
- hold position of page when resized
- prevPage and nextPage: combine code
- <done> equations cause horizontal scrolling
- <done> shortcut menu comes up when horizontally scrolling
- <done> remove formatting from copied codeblock
- <done> add page map to long-click / right-click menu
- <almost done> remove depecated referencing (sectRef...)
- <done> break up code functions
- <done> Title in H6 means no numbers
- Class to add numbers
- <done> switch to addEventListener()
- <done> combine right-click and long-click in one function 
- <done -- use vertical line> fix overflow code
- <done> check MathJax version
- <done> set equation color?  Keep at brown
- <done> cannot put an email link inside H2,H3,H4 -- click event gets removed
    - switched innerHTML for insertAdjacentHTML
- <done - checking for Math element> MathJax is activating long-click menu
Fix hacks in Safari:
- <hacky but done> move vertical line in codeblocks over 22px
- <close -- adds spaces> clipboard works differently in Safari
*/

// tabs in codeblocks are messing with the figures
// tabs are not aligned to the divs because the divs have been shifted
//    you can align by putting the tab inside the div
smallImageHeight = 100;				// set the height of flex-sized objects when small 
//imageHeight = new Array();			// the heights of all flex-sized images in a page
//imageWidth = new Array();			// the widths of all flex-sized images in a page
//minImageWidth = 700;					// minimum width for a flexSize image in expanded mode
scrollTopPosition = 0; 				// value saved for links-return-links within a page
editURL = "";							// URL for the editting page 
referenceTimer = "";					// timer used to toggle the reference object
scrollFlag = 0;  						// counts when scrolling of page occurs due to reference links

// D2L variables 
redNum = -1;						// the number of the class 
instructorEmail = "Charlie Belinsky <belinsky@msu.edu>;";
lessonFolder = "";

// pre-onload functions
addStyleSheet();  // can be done before page load since this is called in the [head]

/*** Handling the long-press menu ****/
longClickTimer = null;
overRCMenu = false;
mouseX = 0; mouseY = 0;  // allow a little wiggle of the mouse

// don't do anything until the parent frame (d2L) loads 
// this still seems to work if there is no parent -- probably should check for this, though
parent.window.onload = function()
{		
	encapObject = document.body; 
  scrollTopPosition = window.parent.scrollY;  
  
  // add styling and copy button to codeblocks that do not have a language
/* codeBlocks = document.querySelectorAll("div.sourceCode > pre");
  
	for(i=0; i<codeBlocks.length; i++)
	{
	  codeBlocks[i].classList.add("sourceCode");
	  codeBlocks[i].classList.add("code-with-copy");
	  codeBlocks[i].classList.add("copy-code");
	}*/
	
  // change symbols to highlighting
  codeBlocks = document.querySelectorAll("pre.mod");
  
  for(i=0; i<codeBlocks.length; i++)
	{
	  newHTML = codeBlocks[i].innerHTML;
	  newHTML = newHTML.replace(/«/g, "<b>");
	  newHTML = newHTML.replace(/»/g, "</b>");
	//  newHTML = newHTML.replace(/&lt;&lt;-/g, "<b>");
	//  newHTML = newHTML.replace(/-&gt;&gt;/g, "</b>");	  
//	  newHTML = newHTML.replace(/&lt;&lt;-(.*)\1-&gt;&gt;/g, "<b>\1</b>");
	  codeBlocks[i].innerHTML = newHTML;
	}
/*
	if(document.querySelectorAll('meta[content^="Joomla"]').length > 0) joomlaFixes();
	
	if(window.location.hostname == "d2l.msu.edu") 
	{
		d2lFixes();
		// Is this the homepage?
		
		url = window.parent.location.href;

		if(!url.includes("d2l.msu.edu/d2l/home/"))
			d2lAddHeader();
	}
*/ 
	
	// adds "code" to elements within bq and moves p out of bq
//	fixBlockquotes();
//	fixBrInCodelines();
//	setCodeBlocks();
//	addBrackets();
	
//	getClassInfoD2L(); // emails, lessons (works only in D2L for now)
	
//	setClassNames();
	
//	fixTitle();
	
	// allow users to resize images from small to full-size
	createFlexImages();
	
	// adds the caption class to all figure elements
//	addCaptions();
	
//	createEmailLink();
	
	equationNumbering();
	
	// structure the page with DIVs based on the headers 
//	addDivs();
	
	// add outline to the divs
//	addOutline();
	
	// Create a right-click menu
	makeContextMenu();  // needs to happen after divs are created

	// adds code tags to all content within an .code tag
	// need to add divs before doing code tags becuase this includes the div codeblocks
//	addCodeTags();
	
	// allow user to toggle the size of the codeblock --used?? needed??
//	addCodeBlockTag();
	
//	codeLineVertBar();
	
//	addReferences();
	
	// convert "download" class to a download hyperlink 
	//		(because D2L does not allow you to specify this trait)
	// addDownloadLinks();	
	
	// check the URL to see if there is a request to go to a specific part of the page
	checkURLForPos();
	
	// target most hyperlinks to a new window
	linksToNewWindow();
	
	// address tag used to create an emphasized textbox
//	createTextBox();
	
	// wrap figure and captions together -- for accessibility
	captionFigures();
			
	// if this page was hyperlinked from elsewhere and a hash tag was added to the link
	if(window.location.hash.slice(1) != "") 
		scrollToElement(window.location.hash.slice(1), true);

	// resize the iframe in the parent window when the page gets resized (if in an iframe)
	if(window !== window.parent && document.body)
	{
		//switch to resizeObserver??
		//document.body.addEventListener("resize", resizeIframeContent());
		//document.getElementById("headerDiv").addEventListener("resize", resizeIframeContent());
		//window.parent.addEventListener("resize", resizeIframeContent());
		//window.addEventListener("resize", resizeIframeContent());
		//	headerDiv = document.getElementsByClassName("headerDiv");	
		//new ResizeObserver(resizeIframeContent).observe(headerDiv[0]);
		new ResizeObserver(resizeIframeContent).observe(document.body);
	//	headerDiv = document.getElementsByClassName("headerDiv");	
	//	headerDiv[0].addEventListener("resize", resizeIframeContent());
	}
}

window.addEventListener("mousedown", function(event)
{
	// make sure it's a left-click and the MathJax Frame is not showing
	if(event.which == 1 && !document.querySelector("#MathJax_MenuFrame"))
	{
		longClickTimer = setTimeout(function() 
		{
			// we are inside a widget
			if(window.location.pathname.includes("customwidgets"))
			{
				editButton = parent.document.querySelectorAll("a.d2l-navigation-s-link"); // look at all buttons
				hasEditAccess = false;
				for(i=0; i<editButton.length; i++)
				{
					if(editButton[i].textContent.includes("Course Admin"))
					{
						hasEditAccess = true; 
					}
				}
				if(hasEditAccess)
				{
					splitUrl = window.location.pathname.split('/');
					theClass = splitUrl[4];
					theWidget = splitUrl[6];
					newUrl = "https://d2l.msu.edu/d2l/lp/homepage/admin/widget/widget_newedit_content.d2l?d2l_isfromtab=1&wid=" +
								theWidget + "&ou=" + theClass;
					openEditor = confirm("Do you want to edit this widget?");
					if(openEditor) window.open(newUrl, '_blank');
				}
			}
			else // we are in a lesson
			{
				activateElement(event, encapObject.querySelector("#longClickMenu"));
				overRCMenu = true;
				encapObject.style.userSelect = "none";
				encapObject.style.msUserSelect = "none";
			}
		}, 350);
		
		// get current mouse pointer position -- used to allow for wiggle in the mouse
		mouseX = parseInt(event.clientX);
		mouseY = parseInt(event.clientY);
	}
});

// disable short-cut menu on scroll (mousemoves are not triggered on scroll)
window.addEventListener("scroll", function(event)
{ 
	clearInterval(longClickTimer);
});
	
window.addEventListener("mouseup", function()
{
	clearInterval(longClickTimer);

	//	tried to avoid this with stopPropogation -- that did not work
	if(!overRCMenu)
	{
		encapObject.querySelector("#longClickMenu").style.visibility = "hidden";
		encapObject.querySelector("#longClickMenu").style.top = "0px";
		encapObject.style.userSelect = "";
		encapObject.style.msUserSelect = "";
	}
});

window.addEventListener("mousemove", function(event)
{
	mouseMoveX = Math.abs(parseInt(event.clientX) - mouseX);
	mouseMoveY = Math.abs(parseInt(event.clientY) - mouseY);
		
	// If the mouse has strayed more than 10 pixels in any direction
	if(mouseMoveX > 10 || mouseMoveY > 10)
	{
		clearInterval(longClickTimer);
	}
});

// will combine the following two functions later...
function activateNotification(e, type)
{
	// create a notification layer is there is not one
	if(!encapObject.querySelector("#notification"))
	{
		// create a new notification layer
		notifDiv = document.createElement("div");
		notifDiv.id = "notification";
		notifDiv.classList.add("rcMenu"); // use same style as menu
		encapObject.appendChild(notifDiv);
	}
	else
	{
		clearInterval(notifTimer);  // make sure the timer is not running
	}
	
	// set the text in the notificaytion layer
	if(type=="code")
	{
		notifDiv.innerHTML = "Codeblock copied to clipboard";
		displayTime = 1000;
		
	}
	else if(type=="scroll")
	{
		notifDiv.innerHTML = "Hold left mouse button to return to previous location";			
		displayTime = 2000;
	}
	
	activateElement(e, notifDiv, -2);

	// set timer for notfication layer
	notifTimer = setTimeout(function()
	{
		notifDiv.style.visibility = 'hidden';
		notifDiv.style.top = '0px';
	}, displayTime);
}

// used for long-click menu, code copying notification, and scrolling notification
function activateElement(e, element, offset = 5)
{			
	const[offsetLeft, offsetTop] = getIframeOffset();
	rcMenuDim = element.getBoundingClientRect();
	
	if(window.innerWidth - e.clientX < rcMenuDim.width)  
	{
		element.style.left = (window.scrollX + e.clientX - rcMenuDim.width + offset) + "px";
	}
	else
	{
		element.style.left = (window.scrollX + e.clientX - offset) + "px";
	}
	
	// need to check if the mouse click happened right above the bottom of the screen
	// or the bottom of the iframe window if in an iframe
	if( ( window.innerHeight - e.clientY < rcMenuDim.height) ||
	    ( window.parent.scrollY + window.parent.innerHeight - offsetTop - e.clientY < rcMenuDim.height ) )
	{
		element.style.top = (window.scrollY + e.clientY - rcMenuDim.height + offset) + "px";
	}
	else
	{
		element.style.top = (window.scrollY + e.clientY - offset) + "px";
	}
	
	element.style.visibility = "visible"; 
}

function fixBlockquotes()
{
	bq = encapObject.querySelectorAll("blockquote");
	
	for(i=0; i<bq.length; i++)
	{
		// find all <p> in the blockquote
		codelines = bq[i].querySelectorAll("p");   // used to include <h6>
 
		if(codelines.length > 0)
		{
			for(j=0; j<codelines.length; j++)
			{
				// add the code class to the children
				codelines[j].classList.add("code");
				// move the object outside of the blockquote
				bq[i].parentNode.insertBefore(codelines[j], bq[i]);
			}
		}
		else if(bq[i].innerText.trim() != "") // the blockquote has something in it
		{
			
			codeLine = document.createElement("p"); 			// create a new codeblock
			codeLine.classList = bq[i].classList;
			codeLine.title = bq[i].title;
			codeLine.innerHTML = bq[i].innerHTML;
			codeLine.classList.add("code");
			bq[i].parentNode.insertBefore(codeLine, bq[i]);
		}
		// remove the blockquote (which is now empty)
		bq[i].parentNode.removeChild(bq[i]);
	}
}

function fixBrInCodelines()
{
	var codeLines = encapObject.getElementsByClassName("code"); 
	
	for(i=0; i<codeLines.length; i++)
	{
		// need to be very careful in for loops where the counted element is changing
		codeElement = codeLines[i];
				
		/* fix the situation where code lines are broken up by [br] --
			usually happens when code was copied/pasted into editor */
		if(codeLines[i].getElementsByTagName("br").length > 0)
		{ 
			// count how many lines of code there are, which is the number of <br> + 1
			// 	because we need to add a break for the last line
			numLines = codeLines[i].getElementsByTagName("br").length +1; 

			var codeText = new Array();
			for(j=0; j<numLines; j++)
			{
				// copy all the lines of code into the array, creating a new line after each <br>
				codeText[j] = codeLines[i].innerHTML.split("<br>")[j];
			}
			for(j=0; j<numLines; j++)
			{
				newElement = document.createElement("p");		// create an [p] 
				newElement.classList.add("code");				// add class "code" to <p>
				newElement.innerHTML = codeText[j];				// insert line from code array in <p>
				if(j == 0)
				{
					// transfer title information to only the first element
					newElement.title = codeLines[i].title;	
					// transfer the class list to the first element					
					newElement.classList =  codeLines[i].classList; 
				}
				// add the new code line to the script
				codeElement.parentElement.insertBefore(newElement, codeElement);  
			}
			// remove all the original code lines
			codeElement.parentElement.removeChild(codeElement);	
			
			/********
			the number of code tags increased -- so codeLines[] has been updated to match
			*********/
			// increase numCodeTags to the current codeline length
			numCodeTags = codeLines.length; 
			
			// increase i by the number of codelines just added (don't need to check those)
			i = i + numLines -1; 
		}
	}
}

function codeBlockFirstLine(codeLine)
{
	codeBlock = document.createElement("p"); 			// create a new codeblock
	/* Check if the code line has an embedded span as the first element -- bug in D2L 
		that ignores the <p> and only sees the embedded <span>
	   Want to apply classes and titles from span to the parent p */
	if(codeLine.innerHTML.startsWith("<span"))	// if the codeline starts with <span
	{
		embedSpan = codeLine.getElementsByTagName("span")[0];
		
		// true only if the embedded span takes up the whole codeline
		if(codeLine.innerText == embedSpan.innerText)
		{
			codeLine.classList = embedSpan.classList;
			codeLine.classList.add("code");  // make sure it is there...
			embedSpan.classList = "";
			codeLine.title = embedSpan.title;
			embedSpan.title = "";
		}
	}		
	codeBlock.classList = codeLine.classList;
	codeBlock.title = codeLine.title;
	codeBlock.classList.add("codeBlock");	
	
	// start numbering at number different than 1
	if( codeBlock.title != "" && !isNaN(codeLine.title) )
	{
		codeBlock.style.counterReset = "codeLines " + (codeLine.title -1);
	}
	
	// when double-clicked, select all the children (text) within the codeblock
	codeBlock.addEventListener("dblclick", function(event){   
		document.getSelection().selectAllChildren(this);  // select everything from the codeblock
		activateNotification(event, "code");              // tooltip indicate code has been copied
		text_only = this.innerText;                       // get text from codeblock
	   text_only = text_only.replaceAll(/\u00A0/g, ' '); // change non-breaking space to space
		/* Hack to get this to work in Safari -- I am not sure why the clipboard work differently for Safari 
		   Note: This seems like a Safari issue -- not a Mac OS issue */
		if(!(navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1))
	   {
			text_only = text_only.replaceAll(/\n\n/g, '\n');  // remove double newlines
		}
	   navigator.clipboard.writeText(text_only);
	});
	
	// disable short-cut menu on scroll (mousemoves are not triggered on scroll)
	codeBlock.addEventListener("scroll", function(event){ 
		clearInterval(longClickTimer);
	});
	
	// add the codeBock div as a parent to the codeLine
	codeLine.parentElement.insertBefore(codeBlock, codeLine);
}

function setCodeBlocks()
{
	// find all code elements that have not been made into codeblocks 
	var codeLines = encapObject.querySelectorAll(".code:not(.codeBlock)");  

	firstLine = true;

	// go through all codelines 
	for(i=0; i<codeLines.length; i++)
	{	
		if(firstLine == true)  // first line of a codeblock
		{
			codeBlockFirstLine(codeLines[i]);	
			firstLine = false;
		}
		codeLine = document.createElement("span");
		codeLine.innerHTML = codeLines[i].innerHTML;
		codeLine.id = codeLines[i].id;
		codeLine.title = codeLines[i].title;  // do I want the title?
		codeLine.classList.add("code");

		// this is the last element in the codeblock
		if(codeLines[i].nextElementSibling == null || 
			!codeLines[i].nextElementSibling.classList.contains("code"))
		{
			firstLine = true;
		}
		else
		{
			codeLine.innerHTML += "<br>";
		}
		
		codeBlock.appendChild(codeLine);
		
		// remove the old codeline
		codeLines[i].parentNode.removeChild(codeLines[i]);
	}
}

	
function getClassInfoD2L()
{
	// find the information for the class
	if(redNum == 755411 || redNum == 704361 || redNum == 457124) 
		instructorEmail = "Charlie Belinsky <belinsky@msu.edu>;";
	else if(redNum == 748323)
		instructorEmail = "Travis Brenden <brenden@msu.edu>;";
	else if(redNum == 942384)
		instructorEmail = "Jim Bence <bence@msu.edu>;";		
	else if(redNum == 931321)
		instructorEmail = "Mike Jones <jonesm30@msu.edu>;";		
	else if(redNum == 952618)
		instructorEmail = "Juan Steibel <steibelj@msu.edu>;";		
}
function resizeIframeContent()
{
	// The iframe containing the content in D2L will only change size 
	// if the content inside increasing in height -- not if it decreases
	// This will change the size anytime
	
	// get iframes from the parent windows:
	parentIFrames = window.parent.document.getElementsByTagName("iframe");
	
	// set height to the total scroll length of the lesson window
	parentIFrames[0].style.height = document.body.scrollHeight + "px";

}

function joomlaFixes()
{
	// In Joomla, the article is in a div of class "container"
	containers = document.querySelectorAll("div.container"); 
	containers[0].style.backgroundColor = "#003c3c";
	containers[0].style.padding = "9px";

	// Joomla uses these itemprprops -- need a better way to check for Joomla...
	itemPropDiv = document.querySelectorAll("div[itemprop]");
	if(itemPropDiv.length == 1)
	{
		// the lesson is encapsulated in the div with the itemprop
		encapObject = itemPropDiv[0];	
		
		// create the editing URL
		// in Joomla it is: URL of page - last section +
		// 			"?view=form&layout=edit&a_id=" + the page id
		theURL = window.location.href; 
		lastSlashIndex = theURL.lastIndexOf("/");
		editURL = theURL.substring(0, lastSlashIndex);
		pageID = theURL.substring((lastSlashIndex +1), theURL.indexOf("-"));
		editURL = editURL + "?view=form&layout=edit&a_id=" + pageID;
	}
	
	// will need to move this line to make it more general
	encapObject.style.backgroundColor = "rgb(0,60,60)";	
}

function d2lFixes()
{
	oldURL = String(window.parent.location); 
	// get rid of parameters (designated by "?")
	editURL = oldURL.split('?')[0];  
	// replace viewContent with contentFile
	editURL = editURL.replace("viewContent", "contentFile"); 
	// replace View with EditFile?fm=0
	editURL = editURL.replace("View", "EditFile?fm=0"); 	 	
				
	// remove the header in the D2L page (being paranoid in case D2L changes their backend)
	if(parent.document.querySelector(".d2l-page-header"))  // we might not be in an iframe
		parent.document.querySelector(".d2l-page-header").style.display = "none";
	if(parent.document.querySelector(".d2l-page-collapsepane-container"))
		parent.document.querySelector(".d2l-page-collapsepane-container").style.display = "none";
	if(parent.document.querySelector(".d2l-page-main-padding"))
		parent.document.querySelector(".d2l-page-main-padding").style.padding = "0";

}

// Add a header to the lesson which include a home, previous, and next page link --
// currently only works in D2L 
function d2lAddHeader()
{
	// check if there is a previous page link
	prevPage = document.body.children[0];
	if(prevPage && prevPage.tagName == "P")
	{
		if(prevPage.innerText.trim() != "")
		{
			prevText = "Previously: " + prevPage.innerText;
		}
		prevPage.parentNode.removeChild(prevPage);
	}
	
	// check if there is a next page link
	nextPage = document.body.children[0];
	if(nextPage && nextPage.tagName == "P")
	{
		if(nextPage.innerText.trim() != "")
		{
			nextText = "Up Next: " + nextPage.innerText;
		}
		nextPage.parentNode.removeChild(nextPage);
	}
		
	if(self != top)
	{	
		// create div at top of page that will hold the home page and page links
		divTop = document.createElement("div");
		divTop.classList.add("headerDiv");
		encapObject.prepend(divTop);
		
		// add home page link
		url = window.parent.location.href;
		classNum = url.match(/\/[0-9]{3,}\//); 
		redNum = classNum[0].substring(1, classNum[0].length-1); // get number of D2L class
		homePage = document.createElement("span");
		homePage.classList.add("lessonLink", "sameWin", "homePage");
		homeLink =  document.createElement("a");
		homeLink.innerHTML = "Home";
		homeLink.href = "https://d2l.msu.edu/d2l/home/" + redNum;
		homeLink.target = "_parent";
		homePage.appendChild(homeLink);
		divTop.appendChild(homePage);
			
		// add the previous page link if it exists
		if(typeof prevText !== 'undefined')
		{
			url = window.parent.document.getElementsByClassName("d2l-iterator-button-prev");
			newPrevPage = document.createElement("span");
			newPrevPage.classList.add("lessonLink", "sameWin", "previousLesson");
			newPrevPageLink = document.createElement("a");
			newPrevPageLink.innerHTML = prevText;
			newPrevPageLink.href = url[0].href;
			newPrevPageLink.target = "_parent";
			newPrevPage.appendChild(newPrevPageLink);
			divTop.insertBefore(newPrevPage, homePage);
		}
		
		// add the next page link if it exists
		if(typeof nextText !== 'undefined')
		{
			url = window.parent.document.getElementsByClassName("d2l-iterator-button-next");
			newNextPage = document.createElement("span");
			newNextPage.classList.add("lessonLink", "sameWin", "nextLesson");
			newNextPageLink = document.createElement("a");
			newNextPageLink.innerHTML = nextText;
			newNextPageLink.href = url[0].href;
			newNextPageLink.target = "_parent";
			newNextPage.appendChild(newNextPageLink);
			divTop.insertBefore(newNextPage, homePage);
		}		
	}
	else
	{
		// old system
		lessonLinks = encapObject.querySelectorAll(".previousLesson, .nextLesson, .nl, .pl");
		for(i=0; i<lessonLinks.length; i++)
		{
			lessonLinks[i].style.display = "none";
		}
	}
}

// add the full name of a class when the user has entered in the abbreviated name
function setClassNames()
{
	// add class names
	p = encapObject.getElementsByClassName("p");
	for(i=0; i<p.length; i++)
	{
		p[i].classList.add("partial");
	}

	nn = encapObject.getElementsByClassName("nn");
	for(i=0; i<nn.length; i++)
	{
		nn[i].classList.add("nonum", "partial");
	}
}

function fixTitle()
{
	// set title on webpage -- the first H1 on the page
	titleObj = encapObject.querySelector("h1");
//	titleObj = encapObject.querySelector("body > h1");
	
	if(titleObj)  // there is a title 
	{
		window.document.title = titleObj.textContent;
		
		// create printer icon 
		printLink = document.createElement('a');
		printLink.classList.add("sameWin");
		printLink.href = "javascript:window.print()";
		printLink.style.marginLeft = "9px";
		printLink.innerHTML = "&#9113"; //"&#x1F5B6;";
	
		// add printer icon to title
		titleObj.appendChild(printLink);
	}
	else
	{
		window.document.title = "No Title";
	}
}

/* removes all of the [div] elements in the page and move the content inside the [div]
   up one level */
function removeDivs()
{
	
	// all DIVs not related to MathJax
	notMathJax = "DIV:not([class*='MathJax']) DIV:not([id*='MathJax'])"
	divElements = encapObject.querySelectorAll(notMathJax);
	
	// Remove all the divs from the page but keep the content 
	while(divElements.length > 0)  
	{		
		// get information inside the div and save it to a temp variable
		divContent = divElements[divElements.length-1].innerHTML
		
		// copy the content of the [div] before the [div] 
		divElements[divElements.length-1].insertAdjacentHTML("beforebegin", divContent);
		
		// remove the [div]
		divElements[divElements.length-1].parentElement.removeChild(
			divElements[divElements.length-1] );
	}
}

/*
Find all images within the page that have the "flexSize" class
and add click events that give the user the ability to change 
the size of the image.  Called on page load.
*/
function createFlexImages()
{
	// find all images that have the class name "flexSize" or "fs"
	var flexImage = encapObject.querySelectorAll('img.flexSize, img.fs');
	var flexVideo = encapObject.querySelectorAll('video.flexSize, video.fs');
	var flexIframe = encapObject.querySelectorAll("p.fs > iframe, p.flexsize > iframe");

	// switch to while (there are flexImages)??
	for(i=0; i<flexImage.length; i++)	// for each flexSize element
	{
		// add a click event that calls changeImageSize() to each flexSize image
		flexImage[i].addEventListener("click", function()
												{ changeImageSize(this) }, false); 
		
		/*** the strange behavior of JS and for loops: final value of the loop  ****/
		
	//	flexImage[i].myIndex = i;  	// give every image a unique index value
		
		// store the values of the images natural width and height
	//	imageHeight[i] = flexImage[i].naturalHeight;
	//	imageWidth[i] = flexImage[i].naturalWidth;
		
		// initalize the flex image to the small size
		changeImageSize(flexImage[i], "minimize");
	}
	
	// go through all the videos...
	for(let i=0; i<flexVideo.length; i++)	// for each flexSize element
	{
		let videoHeight = flexVideo[i].height;
		let videoWidth = flexVideo[i].width;
		flexVideo[i].width = smallImageHeight * videoWidth / videoHeight;
		flexVideo[i].height = smallImageHeight;
		flexVideo[i].addEventListener("play", 
			function()
			{
				this.width=videoWidth; 
				this.height=videoHeight;
			});
		flexVideo[i].addEventListener("ended", 
			function()
			{
				this.width=smallImageHeight * videoWidth / videoHeight;
				this.height=smallImageHeight;
			});
	}
		
	for(let i=0; i<flexIframe.length; i++)
	{
		let iframeHeight = flexIframe[i].height; 
		let iframeWidth = flexIframe[i].width; 
		flexIframe[i].height = smallImageHeight;
		flexIframe[i].width = smallImageHeight * iframeWidth / iframeHeight;

		// create a small span button 
		resizeButton = document.createElement("span");
		resizeButton.classList.add("flexButton");
		resizeButton.classList.add("noSelect");
		resizeButton.innerText = "\u{1f846}";
		resizeButton.addEventListener("click", 
			function()
			{
				if(flexIframe[i].width != iframeWidth)
				{
					flexIframe[i].width = iframeWidth; 
					flexIframe[i].height = iframeHeight; 
					flexIframe[i].src = flexIframe[i].src;
					this.innerText = "\u{1f844}";
				}
				else
				{
					flexIframe[i].width = smallImageHeight * iframeWidth / iframeHeight; 
					flexIframe[i].height = smallImageHeight;
					this.innerText = "\u{1f846}";
				}
			});
		flexIframe[i].parentElement.appendChild(resizeButton);
	}
}

/*
function called when a flexSize image is clicked --
changes the size of images between small and large

possible instruction values: minimize and maximize
*/
function changeImageSize(element, instruction="none")
{
	// get unique index of image
//	imageIndex = element.myIndex;				
	
	// get the images natural width and height unsing the index
//	origHeight = imageHeight[imageIndex];
//	origWidth = imageWidth[imageIndex];
	
	// If image is in small sized mode and insruction is not "minimize"
	// The reason I do not put instruction == "minimize" 
	//			has to do with minimize/maximize all call
	if(element.style.height == smallImageHeight + "px" && instruction != "minimize")
	{
		// get the width of the images parent element, which is a [figure]
	//	screenWidth = element.parentElement.clientWidth;
		
		// if the width is less than the min width, increase the width to the min width
	/*	if(screenWidth < minImageWidth)
		{
			screenWidth = minImageWidth;
		}*/
		
	//	element.style.width = "unset";
		element.style.height = "unset";
			
		// if the natural width of the image is smaller than the screen width...
	/*	if(origWidth <= screenWidth)
		{
			// set the image to its natural size
			element.style.width = origWidth + "px";
			element.style.height = origHeight + "px";
		}
		else  // image's natural width is larger than screen width
		{
			// set the image width to the screen width and scale the height
			element.style.width = screenWidth + "px";
			element.style.height = (screenWidth/origWidth)*origHeight + "px";
		}*/
	}
	else if (instruction != "maximize")
	{
		// set the images height to the smallHeight value and scale the with to match
		element.style.height = smallImageHeight + "px";	
		element.style.width = "auto";	
		//element.style.width = (smallImageHeight/origHeight)*origWidth + "px";
	}
}

/* uses the header structure of the page to create a visual style with div elements --
	user passes in the elementType they want to structure 
	(H1, H2, and H3 are currently supported */ 
function addDivs()
{
	// find all element of the type asked for (H1, H2, and H3 that are direct children of the body are currently supported)
	elements = encapObject.querySelectorAll("h1, h2, h3");
//	elements = encapObject.querySelectorAll("body > h1, body > h2, body > h3");
	
	// for each header element
	for(i=0; i<elements.length; i++)
	{
		// create a temporary element at the same location of the Header element
		currentElement = elements[i];
		nextSibling = null;
	
		newDiv = document.createElement("div");	// create a new div
					
		// get title from element -- transfer to new div
		// use data-title instead of title because 
		//		title will create a tooltip popup (which I don't want)
		if(elements[i].title != "")
		{
			newDiv.dataTitle = elements[i].title
		}
		else  // no title -- use text from header
		{
			newDiv.dataTitle = elements[i].innerText;
		}
		
		// insert the new div right before the Header element
		elements[i].parentNode.insertBefore(newDiv, elements[i]);
		/*
			Go from 
			<h2> Header title </H2>
				<p>more content</p>
				<p>more content</p>
				<p>more content</p>
			<h3>
			
			to
			
			<div class="">
				<h2> Header title </H2>
				<p>more content</p>
				<p>more content</p>
				<p>more content</p>
			</div>
			<h3>  -- this last element could also be <h2>, <div>, or end-of-page
		*/
		while(currentElement.nextElementSibling != null &&
				currentElement.nextElementSibling.tagName != "H1" &&
				currentElement.nextElementSibling.tagName != "H2" &&
				currentElement.nextElementSibling.tagName != "H3" &&
				!(currentElement.nextElementSibling.classList.contains("h1Div")) && 
				!(currentElement.nextElementSibling.classList.contains("h2Div")) && 
				!(currentElement.nextElementSibling.classList.contains("h3Div"))) 
		{
			nextSibling = currentElement.nextElementSibling;	// get the next element
			newDiv.appendChild(currentElement);						// add current element to div
			currentElement = nextSibling;					// set current element to next element
		}	

		// add the page title class to the div with H1
		if(elements[i].tagName == "H1")
		{	
			newDiv.classList.add("h1Div");
		}
		else if(elements[i].tagName == "H2")
		{	
			// add the class "h2Div" to div with H2
			newDiv.classList.add("h2Div", "contentDiv");
			
			// add "nonlinear" class for div that contain non-linear content
			if((elements[i].className != "" ) &&
				(elements[i].classList.contains("trap") ||
				elements[i].classList.contains("extension") ||
				elements[i].classList.contains("shortcut")) )
			{
				newDiv.classList.add("nonlinear");
			}
		}
		else if(elements[i].tagName == "H3")
		{	
			// add the class "h3Div" to div with "H3"
			newDiv.classList.add("h3Div", "contentDiv");
			
			// Check to see if the previous sibling (div with H2 or H3) has class "nonlinear"
			// if so -- then this div should also be class "nonlinear"
			if(newDiv.previousElementSibling && 
				newDiv.previousElementSibling.className != "" &&
				(newDiv.previousElementSibling.classList.contains("nonlinear") ))
			{
				newDiv.classList.add("nonlinear");
			}
		}	

		if(currentElement.nextElementSibling == null) // there is no next
		{
			// should change at some point -- probably indicates an error
			newDiv.classList.add("h2NextDiv");	
		}
		else if(currentElement.nextElementSibling.tagName == "H2" ||
					currentElement.nextElementSibling.classList.contains("h2Div"))
		{
			newDiv.classList.add("h2NextDiv");	// it is the end of a section
		}
		else if(currentElement.nextElementSibling.tagName == "H3" ||
					currentElement.nextElementSibling.classList.contains("h3Div"))
		{
			newDiv.classList.add("h3NextDiv");	// it is the middle of a section
		}
		newDiv.appendChild(currentElement);	// add content to the new div
	}
}

// add outline to H2 and H3 elements
function addOutline()
{
	level1 = 0;
	level2 = 0;
	divElement = encapObject.getElementsByTagName("div");
	
	for(i=0; i<divElement.length; i++)
	{
		// find what the first element in the div is
		if(divElement[i].firstChild && divElement[i].firstChild.tagName == "H2")
		{
			level1++;			
			level2=0;
			divElement[i].firstChild.insertAdjacentHTML("afterbegin", level1 + " - ");
			divElement[i].dataTitle = divElement[i].firstChild.textContent;
		}
		else if(divElement[i].firstChild && divElement[i].firstChild.tagName == "H3")
		{
			level2++;
			divElement[i].firstChild.insertAdjacentHTML("afterbegin", level1 + "." + level2 + " - ");
			divElement[i].dataTitle = divElement[i].firstChild.textContent;
			
			// find H4 elements within H3
			h4Elements = divElement[i].getElementsByTagName("H4");
			
			level3 = 0;
			for(j=0; j<h4Elements.length; j++)
			{
				level3++;
				h4Elements[j].insertAdjacentHTML("afterbegin", level1 + "." + level2 + "." + level3 + " - ");
				h4Elements[j].dataTitle = h4Elements[j].textContent;
			}
		}
	}
}

/* call from right-click menu in page to either minimize or maximize (param)
	all the flex-sized images in the page */
function changeAllPicSize(param)
{
	var flexImage = encapObject.querySelectorAll('.flexSize, .fs');
	for(i=0; i<flexImage.length; i++)
	{
		/* calll changeImageSize passing each flexSize object in an array */
		changeImageSize(flexImage[i], param)
	}
}

/* Linkback function */
function goBackToPrevLocation()
{
	leftPos = window.parent.scrollX; 	// get the left position of the scroll

			    
	prevLocLink = document.getElementById("previousLocMenuItem");
	prevLocLink.classList.add("disabledLink"); 
	
  newScrollTopPosition = window.parent.scrollY;  
	// scroll the page vertically to the position the page was
	// at when the link was originally clicked (stored as a global variable)
	window.parent.scrollTo(leftPos, scrollTopPosition);
	scrollTopPosition = newScrollTopPosition;
	//return false;	// so the page does not reload (don't ask why!)
}
	
/* link to external CSS file 
	This is in the javascript because D2L will rewrite links in the HTML file */
function addStyleSheet()
{
	var CSSFile = document.createElement("link");
	scripts = document.getElementsByTagName("script");
	for(i=0; i<scripts.length; i++)
	{
		//jsIndex = scripts[i].src.indexOf("module.js");
		// check for module in the script file name -- this is my code
		if(scripts[i].src.includes("module")) // (jsIndex != -1) 
		{
			// script file and css file have same name and different extension
			cssFile = scripts[i].src.slice(0,-2) + "css"; 
			// cssFile = scripts[i].src.substring(0,jsIndex) + "module.css";
		}
	}
	CSSFile.href = cssFile;	// location depends on platform
	CSSFile.type = "text/css";
	CSSFile.rel = "stylesheet";
	CSSFile.media = "screen,print";
	document.getElementsByTagName("head")[0].appendChild(CSSFile);
}

/* adds the class "eqNum" to all figures that have the dotum font (it's a hack for D2L) */
function equationNumbering()
{
	// find all elements that are equation numbers
	var equations = encapObject.getElementsByClassName("eqNum");
	
	// add the equation number after the equation
	for(i=0; i<equations.length; i++)
	{
		if(equations[i].textContent.trim() != "")
		{		
			eqNumber = document.createElement("span");
			eqNumber.classList.add("eqNum");
			eqNumber.id = equations[i].id;
			
			eqNumber.textContent =  "\u00a0( " + (i+1) + " )";

			equations[i].appendChild(eqNumber);
			
			// remove class from original element -- otherwise class could be applied to whole equation
			equations[i].id = "";
			equations[i].classList.remove("eqNum");   
		}
	}
}

/* adds the class "caption" to all figures */
function addCaptions()
{
	// find all elements with "fig" class
	var captionLines = encapObject.querySelectorAll(".fig");  // used to include "h5"

	// this is deprecated in DreamWeaver
	for(i=0; i<captionLines.length; i++)
	{
		if(!(captionLines[i].classList.contains("eqNum")))
		{
			captionLines[i].classList.add("caption");	
		}
	}
	
	// In DW: the class .caption is an option
	captionLines = encapObject.getElementsByClassName("caption");
	for(i=0; i<captionLines.length; i++)
	{
		if(captionLines[i].innerText.trim() != "")  // there is text in the caption
		{
			captionLines[i].insertAdjacentHTML("afterbegin", "Figure " + (i+1) + ": ");
		}	
	}
}

function addBrackets()
{
	bracketCode = encapObject.querySelectorAll("p.bx");
	
	for(i=0; i<bracketCode.length; i++)
	{
		// add extra padding to each line:
		codeLines = bracketCode[i].querySelectorAll(".code");
		for(j=0; j<codeLines.length; j++)
		{
			codeLines[j].innerText = "\u00A0\u00A0" + codeLines[j].innerText;
		}
		
		/**** added formatting to put in {} ***********/
		// create a line that just has a start curly bracket ( { )
		startCodeLine = document.createElement("span");
		startCodeLine.setAttribute("data-text", "{");  // so it does not appear as text when selected
		startCodeLine.classList.add("code", "firstLine", "noSelect", "noCode");

		bracketCode[i].prepend(startCodeLine);
		
		// create a line that just has a start curly bracket ( } )
		endCodeLine = document.createElement("span");
		endCodeLine.setAttribute("data-text", "}");  // so it does not appear as text when selected
		endCodeLine.classList.add("code", "firstLine", "noSelect", "noCode");

		bracketCode[i].append(endCodeLine);	
	}
}

function addCodeBlockTag()
{
	codeBlockDivs = encapObject.querySelectorAll(".codeBlock");
		
	for(i=0; i<codeBlockDivs.length; i++)
	{		
		// need to check if there is a title in the first element of the codeblock
		codeBlockTitle = "";
		if(codeBlockDivs[i].title.trim() != "" && isNaN(codeBlockDivs[i].title.trim())) 			
		{
			codeBlockTitle = codeBlockDivs[i].title;
		}
		else 
		{
			// if not, check the children elements to see if there is a title (this is a D2L bug)
			cbChild = codeBlockDivs[i].querySelector("[title]");
			if(cbChild && cbChild.title.trim() != "" && isNaN(cbChild.title.trim()))
			{
				codeBlockTitle = cbChild.title;
			}
		}

		// add a pop-up tab to the codeblock
		if(codeBlockTitle != "")	
		{
			par = document.createElement("p");
			par.classList.add("noSelect");
			par.style.textAlign = "left";
			tabSpan = document.createElement("span");
			tabSpan.classList.add("codeBlockTab", "noSelect", "noCode", "nonum");
			tabSpan.setAttribute("data-text", codeBlockTitle);
			par.appendChild(tabSpan);
		   // position is still off by a bit...
			codeBlockDivs[i].parentNode.insertBefore(tabSpan, codeBlockDivs[i]);
		}
	}
}

function codeLineVertBar()
{
	// find all codeblocks
	codeBlocks = document.getElementsByClassName("codeBlock");
	
	const myObserver = new ResizeObserver(entries => {
			  entries.forEach(entry => {
				  vertLine = entry.target.querySelector(".vertBar");
				  vertLine.style.height = 0;
				 // vertLine.style.height = entry.contentRect.height + "px";
				  vertLine.style.height = entry.target.clientHeight + "px";
			})
	});
			
	// for each line of code in the page
	for(i=0; i<codeBlocks.length; i++)
	{
		// Check if the codelines are to be numbered... 
		if(codeBlocks[i].classList.contains("num"))
		{
			// get the actual height the codeline 
			actualHeight = codeBlocks[i].clientHeight;  // replaces scrollHeight
			vertLine = document.createElement("hr");
			vertLine.classList.add("vertBar");
			vertLine.style.height = actualHeight + "px";
			
			/* Hack to get this to work in Safari -- I am not sure why the CSS does not work for Safari */
			if(navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1)
			{
				vertLine.style.marginLeft = "22px";
			}
			
			// if codeblocks changes size, change the vertical line size
			myObserver.observe(codeBlocks[i]);

			codeBlocks[i].prepend(vertLine);
		}
	}
}

function goToTopOfPage()
{
	// save current scroll position
	scrollTopPosition = window.parent.scrollY;  
	// scroll to position 0
	window.parent.scrollTo(window.parent.scrollX, 0);
	enablePrevious();
}

function makeContextMenu(funct, param = null)
{	
	var elemDiv = document.createElement('div');
	elemDiv.id = "longClickMenu";
	elemDiv.classList.add("rcMenu");
	elemDiv.addEventListener("mouseenter", function() {overRCMenu = true;}); 
	elemDiv.addEventListener("mouseleave", function() {overRCMenu = false;}); 
	
	var scTitle = document.createElement('a');
	elemDiv.innerHTML = "<b>Shortcut Menu</b>";
	elemDiv.style.display = "block";
	elemDiv.classList.add("sameWin", "noSelect");
	elemDiv.appendChild(scTitle);
	
	// check if the user is has editing privileges by seeing if the Edit HTML button is there
	editButton = parent.document.querySelectorAll("button.d2l-button"); // look at all buttons
	hasEditAccess = false;
	for(i=0; i<editButton.length; i++)
	{
		if(editButton[i].textContent.includes("Edit HTML"))
		{
			hasEditAccess = true; 
		}
	}
	
	if(hasEditAccess == true) // use has editing right -- show Edit option in menu
	{
		oldURL = String(window.parent.location);  // otherwise you will edit the URL
		newURL = oldURL.replace("viewContent", "contentFile"); 
		newURL = newURL.replace("View", "EditFile?fm=0"); 
		menuLinks(elemDiv, "Edit Page", function(){window.open(newURL, '_blank')}, "editPage");
	}
	menuLinks(elemDiv, "Return to previous location", goBackToPrevLocation, "previousLocMenuItem", false);
	menuLinks(elemDiv, "Go to Top of Page", goToTopOfPage, "topMenuItem");
	menuLinks(elemDiv, "Print/ Save as PDF", function(){document.getElementById("longClickMenu").style.visibility = "hidden"; window.print()}, "printToPDF");
	menuLinks(elemDiv, "Maximize All Images", function() {changeAllPicSize('maximize')}, "maxAllImages");
	menuLinks(elemDiv, "Minimize All Images", function() {changeAllPicSize('minimize')}, "minAllImages");
	
	encapObject.appendChild(elemDiv);
}

function menuLinks(menu, text, command, linkid="", enable=true)  
{
	// create a block span to encapsulate the hyperlink
	spanEncap = document.createElement('span');
	spanEncap.style.display = "block";
		
	link = document.createElement('a');
	if(!enable)
		link.classList.add("disabledLink");
	link.id = linkid;
	link.innerText = text;
	link.classList.add("sameWin", "jsLink");
	link.addEventListener("mouseup", 
								 function(event) 
								 { 
									command(); 	
									document.getElementById("longClickMenu").style.visibility = "hidden"; 
									document.getElementById("longClickMenu").style.top = "0px"; 
								 });
	spanEncap.appendChild(link);
	
	menu.appendChild(spanEncap);
}

function scrollToElementReturn(elementID)
{
	// this resolves the fact that variables are function scoped in JavaScript
	//   -- not block scoped
	return function() 
	{
		scrollToElement(elementID);	
	}
}

function copySelectedText()
{
	var text = "";
	if (window.getSelection)   // if there is something selected on the page
	{
		// works in all browsers except Firefox (current bug as of version 51)
		text = window.getSelection().toString();	// convert selected stuff to a string
		a = document.execCommand("copy");			// copy stuff to clipboard
	} 
}

function addDownloadLinks()
{
	downloadLinks = encapObject.getElementsByClassName("download");

	for(i=0; i<downloadLinks.length; i++)
	{
		// add the download property to all objects with class="download"
		downloadLinks[i].download = "";
	}
}

// checks in the references is on a block-displayed object.  If so,
// we need to create an inline-display object inside and put the 
// reference there
function fixBlockReferences()
{
	var references = encapObject.querySelectorAll(".ref");

	for(i=0; i<references.length; i++)
	{
		// get the display type of the reference element
		displayType = window.getComputedStyle(references[i], "").display;
		
		// if the element is block or list-item -- both take up the whole line
		if(displayType == "block" || displayType == "list-item")
		{
			// create a new <span> and copy the contents of the ref element
			newRef = document.createElement("span");
			newRef.innerHTML = references[i].innerHTML;
			
			// copy the id and add ref class to <span>
			newRef.id = references[i].id;
			newRef.classList.add("ref");
			
			// remove all content, id, and ref class from reference element
			references[i].innerHTML = "";
			references[i].id = "";
			references[i].classList.remove("ref");
			
			// append the new <span> inside the reference element
			references[i].appendChild(newRef);	
		}
	}
}

/* finds all section references in the page and add the correct numerical reference */
function addReferences()
{
	fixBlockReferences();
	
	/**** convert old system of references to the new system ****/
	var references = encapObject.querySelectorAll(".sectRef, .figureRef, .eqRef, .linkTo");
	for(i=0; i<references.length; i++)
	{
		// old system to new system
		references[i].classList.add("ref");
	}
	
	// new system for references
	var references = encapObject.querySelectorAll(".ref, .reference");
	for(i=0; i<references.length; i++)
	{
		fullRefID = references[i].id; // Get the ID for the reference
		refID = fullRefID.slice(2);	// remove the "r-" at the beginning of the ID
	
		// check if the reference has no ID
		if(fullRefID == "")  
		{
			// this situation is currently handled in editor.CSS
		}
		// no text associated with the reference
		else if (references[i].innerText.trim() == "")
		{
			// this situation is currently handled in editor.CSS			
		}
		// check if ID has any invalid characters
		else if(isValid(refID) == false)
		{
			references[i].classList.add("error");
			references[i].innerText = "**Invalid characters in ID: " + 
												references[i].innerText + "** ";
		}
		// check if the ID starts with a number
		else if(isNaN(refID[0]) == false)
		{
			references[i].classList.add("error");
			references[i].innerText = "**Cannot start ID with number: " + 
												references[i].innerText + "** ";
		}
		// this is a URL link to a different page
		else if(references[i].hasAttribute("href"))
		{
			// check to see if the href already has a "?" in it --
			// the ? indicates there are already parameters attached to the URL
			if(references[i].href.includes("?"))  // add another param called ref
			{
				references[i].href = references[i].href + "&ref=" + refID;
			}
			else  // add first param called ref
			{
				references[i].href = references[i].href + "?ref=" + refID;		
			}
		}
		// uses the title instead of a URL to indicate a ref to an outside lesson
		else if (references[i].title != "")
		{
			url = window.location.protocol + "//" + window.location.hostname + 
					window.location.pathname;
			n = url.lastIndexOf("/");  // find the last front slash
			lessonFolder = url.substr(0, n+1);
			newLessonURL = lessonFolder + references[i].title + "#" + refID;
			references[i].addEventListener("click", function() {window.open(newLessonURL)});
		}
		// reference link does not exist in the page
		else if(!(encapObject.querySelector("#" + refID)))
		{
			references[i].classList.add("error");
			references[i].innerText = "**Invalid Link: " + 
												references[i].innerText + "** ";				
		}
		// there is no content at the link (not sure this is neccessary...)
		else if (encapObject.querySelector("#" + refID).innerText.trim() == "")
		{
			references[i].classList.add("error");
			references[i].innerText = "**No content at link: "  + 
												references[i].innerText + "** ";					
		}
		// if this is a reference to an equation -- 
		else if(encapObject.querySelector("#" + refID).classList.contains("eqNum")  ||
				  encapObject.querySelector("#" + refID).classList.contains("eq") ||
			     encapObject.querySelector("#" + refID).classList.contains("equation")) 
		{
			caption = encapObject.querySelector("#" + refID).innerText;

			/* find the last "(" in the line -- represents ( EQ# )
			   split the line right after the "(" -- so you have EQ#) left
				grab the number from the split of section */
			eqRef = parseInt(caption.slice( (caption.lastIndexOf("("))+1 ));
			
			addNumToReference(references[i], eqRef);
		}
		// if this is a figure ref (has fig class but not eqNum class)
		else if(//encapObject.querySelector("#" + refID).nodeName.toLowerCase() == "h5" || // old system
              encapObject.querySelector("#" + refID).classList.contains("fig"))        // new system
		{
			caption = encapObject.querySelector("#" + refID).innerText;
			strIndex = caption.indexOf(":");  // find the location of the first semicolon
			
			//cheap fix -- use grep to check for numbers (future fix)
			figRef = caption.slice(4, strIndex); // get "Fig. #"
			
			addNumToReference(references[i], figRef);
		}
		// this links to a section header (h2-h4)
		else if(encapObject.querySelector("#" + refID).nodeName.toLowerCase() == "h2" ||
				  encapObject.querySelector("#" + refID).nodeName.toLowerCase() == "h3" ||
				  encapObject.querySelector("#" + refID).nodeName.toLowerCase() == "h4") 
		{
			// get first number from section ID (div)
			sectNum = parseFloat(encapObject.querySelector("#" + refID).innerText);
			
			addNumToReference(references[i], sectNum);
		}
		// for codelines
		else if(//encapObject.querySelector("#" + refID).nodeName.toLowerCase() == "h6" ||
		        encapObject.querySelector("#" + refID).nodeName.toLowerCase() == "code")
		{
		//	Note: there is no way to access the CSS pseudo counter in JavaScript
		// Fix: Need to check for offset number
		
			cl = encapObject.querySelector("#" + refID);
			clParent = cl.parentNode;
			lineNum = Array.prototype.indexOf.call(clParent.children, cl);

			// the title of the codeblockdiv potentially has the numbering offset
			if(cl.parentNode.title && !isNaN(cl.parentNode.title))
			{
				lineNum = lineNum + parseInt(cl.parentNode.title);
			}				
			
			addNumToReference(references[i], lineNum);
		}
		// for all other elements referenced in the page -- often these elements
		// are <span> inside another element (a D2L bug) -- so we need to check parent
		// elements 
		else 
		{
			refObject = encapObject.querySelector("#" + refID);
			parentObj = refObject.parentNode.nodeName.toLowerCase();
			refNum = -1;
				
			if(parentObj && parentObj.firstElementChild &&
					  parentObj == "div" && 
								(parentObj.firstElementChild.nodeName.toLowerCase() == "h2" ||
								 parentObj.firstElementChild.nodeName.toLowerCase() == "h3" ||
								 parentObj.firstElementChild.nodeName.toLowerCase() == "h4") )
			{
				strIndex = caption.indexOf("-");  // find the location of the first dash
				refNum = parentObj.firstElementChild.innerText.slice(0, (strIndex-2));
			}
			else if(parentObj.parentNode)
			{
				grandParent = parentObj.parentNode.nodeName.toLowerCase();
				if(grandParent == "div" && 
								(grandParent.firstElementChild.nodeName.toLowerCase() == "h2" ||
								 grandParent.firstElementChild.nodeName.toLowerCase() == "h3" ||
								 grandParent.firstElementChild.nodeName.toLowerCase() == "h4") )
				{
					strIndex = caption.indexOf("-");  // find the location of the first dash
					refNum = parentObj.firstElementChild.innerText.slice(0, (strIndex-2));
				}
			}
			
			if(refNum != -1)
			{
				str = references[i].innerText;
				var pos = str.lastIndexOf('##');
				references[i].innerText = str.substring(0,pos) + eqRef + str.substring(pos+2);
			}
			
			// make the reference linkable as long as the nolink class is not 
			//				specified (not working yet...)
			if( !(references[i].classList.contains("nolink")) )
			{
				references[i].addEventListener("click", scrollToElementReturn(refID));
			}
		}
	}
}

function addNumToReference(refObj, refNum)
{
	refIndex = refObj.innerText.indexOf("##");
	
	if(refIndex != -1)
	{
		str = refObj.innerText;
		var pos = str.lastIndexOf('##');
		refObj.innerText = str.substring(0,pos) + 
								 refNum + str.substring(pos+2);
	}
	
	// make the reference linkable as long as the nolink class is not 
	//		specified (not working yet...)
	if( !(refObj.classList.contains("nolink")) )
	{
		refObj.addEventListener("click", scrollToElementReturn(refID));
	}
}

function checkURLForPos()
{
	// In D2L, the page is inside an iframe -- so need to check the parent
	var urlString = parent.window.location.href;
	var url = new URL(urlString);
	var ref = url.searchParams.get("ref");
	
	if(ref != null)
	{
		scrollToElement(ref);
	}
}

function scrollToElement(elementID, outsideCall = false)
{		
//	var element = encapObject.querySelector("#" + elementID); 
	var element = document.getElementById(elementID); 
	var windowHeight = window.parent.innerHeight;// height of the webpage with the lesson
	var windowScroll = window.parent.scrollY; 	// amount window has been scrolled
	var divWindowScroll = 0;							// for object in a scrolling div

	// find the position of the iframe -- if content is not in iframe this will return 0,0
	const [offsetLeft, offsetTop] = getIframeOffset();
	
	// check if the referenced element is a codeline in a div that has a scrollbar
	if(element.classList.contains("code")  &&   // part of a codeBlock
		element.parentNode.scrollHeight > element.parentNode.clientHeight) // scrollbar on codeblock
	{
		// line is scrolled out of view
		if(element.offsetTop < element.parentNode.scrollTop || 
			element.offsetTop > element.parentNode.scrollTop + element.parentNode.offsetHeight) 
		{
			element.parentNode.scrollTop = element.offsetTop - 20;  // scroll line back into view
		}
		divWindowScroll = element.parentNode.scrollTop;  // get the current scroll position
	}

	// calc the vertical position of the linked element in the parent page
	elementYPos = element.offsetParent.offsetTop + element.offsetTop + offsetTop - divWindowScroll; 
	
	// if the element is not on the screen
	if(elementYPos < windowScroll || elementYPos > (windowScroll+(2*windowHeight)))
	{
		// add some padding so the object does not appear right at the top of the page
		if(element.classList.contains("caption"))
		{
			offsetPadding = 200;	// add more padding if this is an image
		}
		else
		{
			offsetPadding = 50;
		}
		
		// save the current value of the scroll position so we can return to this spot
		scrollTopPosition = window.parent.scrollY; 
		
		// scroll the parent to the vertical position of the linkTo element
		window.parent.scrollTo(element.offsetLeft, (elementYPos -offsetPadding) );	
		
		scrollFlag = scrollFlag +1;
		if(scrollFlag <= 2) {activateNotification(event, "scroll");}
		enablePrevious();
	}
	// if the scrolling-to element is within one page
	else if(elementYPos >  (windowScroll+windowHeight) && elementYPos < (windowScroll+ (2*windowHeight)))
	{
		offsetPadding = windowHeight - 200;
		
		// save the current value of the scroll position so we can return to this spot
		scrollTopPosition = window.parent.scrollY; 
		
		// scroll the parent to the vertical position of the linkTo element
		window.parent.scrollTo(element.offsetLeft, (elementYPos -offsetPadding) );	
		enablePrevious();
	}
	
	highLightObject(element, 2000);
}

function highLightObject(element, time=2000)
{
  // for headers 
  //refElement = document.querySelector("[data-anchor-id=" + element.id + "]");
  refElement = document.querySelector("[data-anchor-id='" + String(element.id) + "']");
  if(!refElement)
  {
    // for all but headers
    refElement = document.querySelector("#" + element.id);
  }
  
  // spans cannot have background color, so change element to parent of span
  if(refElement.tagName == "SPAN")
  {
    refElement = refElement.parentElement; 
  }
  			    
	// check if there already is an object being highlighted
	if(encapObject.querySelector(".refObjHighlight"))
	{
		encapObject.querySelector(".refObjHighlight").classList.remove("refObjHighlight");
		clearInterval(referenceTimer);
	}

	refElement.classList.add("refObjHighlight");
	referenceTimer = setTimeout(function() 
	{
		refElement.classList.remove("refObjHighlight");
	}, time);
}

// get the top and left position of the iframe within the parent window
function getIframeOffset()
{
	offsetLeft = 0;
	offsetTop = 0;	
	
	// check if the lesson is in an iframe
	if (window.self !== window.top)  // we are in an iframe
	{
		// get iframes from the parent windows:
		parentIFrames = window.parent.document.getElementsByTagName("iframe");
			
		// go through iframe to find which has the same source as this lesson  
		// 	(i.e., the iframe that contains this page)
		for(i=0; i<parentIFrames.length; i++)	// most likely there is only one iframe!
		{
			// this is the iframe that conatins the lesson
			if (window.location.href == parentIFrames[i].src) 
			{
				// distance between the top of this iFrame at the top of the parent window
				offsetLeft = parentIFrames[i].offsetLeft; 	
				offsetTop = parentIFrames[i].offsetTop; 
				break;  // don't need to check any more iframes
			}
		}
	}
	return[offsetLeft, offsetTop];
}

function enablePrevious()
{	
	// change the right-click menu to show the return link
	prevLocLink = document.getElementById("previousLocMenuItem");
	prevLocLink.classList.remove("disabledLink");
}

function linksToNewWindow()
{
	links = encapObject.querySelectorAll('a[href]');
	
	for(i=0; i<links.length; i++)
	{
		// only change href that go to the same page... will need to update this or it 
		// will include anything within the same site.
		if (links[i].href.indexOf(window.location.pathname) > -1)
		{
		  hashPos = links[i].href.indexOf("#");
	    hashID = links[i].href.substring((hashPos+1));
			links[i].removeAttribute("href");  
			links[i].classList.add("inpageLink"); 
						
			(function(hashID){
  			links[i].addEventListener("click", 
  			  function() { 
  
  			 //   element = document.querySelector(hashID);
            element = document.getElementById(hashID);
            // for headers 
            
  			    refElement = document.querySelector("[data-anchor-id='" + String(element.id) + "']");
  			    if(!refElement)
  			    {
  			      // for all but headers
  			      refElement = document.querySelector("#" + element.id);
  			    }
  			    scrollToElement(element.id);

  		//	    scrollTopPosition = window.parent.scrollY;  
  		//	    highLightObject(refElement, 2000);
  			  });	
			})(hashID);
		}
		else if(links[i].href.trim() != "" &&                        // link is not blank
	// 	   !links[i].href.includes("/#") &&                     // first char in path is not #
	//	   !(links[i].classList.contains("sameWin")) &&          // link does not contain class sameWin
	//   	 !(links[i].classList.contains("download")) &&         // link does not contain class download
		 	 !(links[i].classList.contains("quarto-xref")) &&      // link does not contain class quarto-xref
		 	 (links[i].target == "_self" || !(links[i].target)) )  // link contains instruction to go to same window
		{
			links[i].target = "_blank";
		}

	}
}

function createEmailLink()
{
	emailLink = encapObject.getElementsByClassName("email");

	for(i=0; i<emailLink.length; i++)
	{
		// the title of the element should be an email address
		emailLink[i].addEventListener("click", function() {openEmailWindow(this.title);});
	}
}

function openEmailWindow(emailAddress)
{
	emailWindow = window.open("https://d2l.msu.edu/d2l/le/email/" + 
										redNum + "/ComposePopup");
	  
	emailWindow.onload = function() 
	{		
		header = emailWindow.document.body.querySelector(".vui-heading-1");
		header.innerText = "Send Message to Instructor";
			
		addressControl = emailWindow.document.getElementById("ToAddresses$control");
		addressControl.click();
		address = emailWindow.document.getElementById("ToAddresses");
		address.focus(); 
		if(emailAddress == "") emailAddress = instructorEmail;  // no email given -- go to default
		address.value = emailAddress;			
		
		subject = emailWindow.document.getElementById("Subject");
		subject.value = window.document.title;
	};
}

function fixIframeSize()
{
	iFrame = window.parent.document.getElementsByClassName("d2l-iframe");
	if (iFrame[0])
	{
		/* This might only be a FireFox Developers Edition issue -- 
			in which case it can be removed */
		iFrame[0].style.height = document.documentElement.scrollHeight + "px";
		setTimeout(function() 
					{
						iFrame[0].style.height = document.documentElement.scrollHeight + "px";
					}, 9000);
	}
}

function isValid(str)
{
	return !/[~`!#$%\^&*+=\[\]\\';,/{}|\\":<>\?]/g.test(str);
}

function createTextBox()
{
	textLine = encapObject.querySelectorAll("address");
	
	firstLine = true;
	lastLine = false;
	for(i=0; i<textLine.length; i++)
	{
		if(firstLine == true)
		{
			// start a new div
			textBoxDiv = document.createElement("div");
			textBoxDiv.classList.add("textBox");
			textBoxParent = textLine[i].parentNode;
			textBoxParent.insertBefore(textBoxDiv, textLine[i]);
			firstLine = false;
		}
		// check if the next line is an address
		if(!(textLine[i].nextElementSibling) || textLine[i].nextElementSibling.tagName != "ADDRESS")
		{
			firstLine = true;
		}
		
		// add textLine to div
		textBoxDiv.appendChild(textLine[i]);
	}
}

function captionFigures()
{
	// find all objects with class="caption" (figures)
	captions = encapObject.querySelectorAll(".caption");
	
	for(i=0; i<captions.length; i++)
	{
		// get the previous sibling for the caption (probably a <p>)
		prevSibling = captions[i].previousElementSibling;
		
		
		/*** <br> are an issue -- 
		  could remove break and take the previous sibling of the break ***/
		  
		// don't attach a caption to an already existing figure or another caption
		//  -- no recursive figure-ing!
		if(prevSibling &&   // just in case there is no prevSibling (somebody puts a fig in a list...)
			prevSibling.tagName.toLowerCase() != "figure" &&
		   prevSibling.tagName.toLowerCase() != "br" &&   // kluge for now
			!(prevSibling.classList.contains("caption")) )
		{		
			// find the first image within the prevSibling (should only be one)
			//figureObj = prevSibling.querySelector("img");

			// create a new figure caption -- copy old caption
			figureCaption = document.createElement("figcaption");	
			figureCaption.classList = captions[i].classList;
			figureCaption.innerHTML = captions[i].innerHTML; // need ID?
			figureCaption.id = captions[i].id; // need ID?
			
			// create a new figure -- copy from previous sibling and add caption
			figureElement = document.createElement("figure");
			
			// put new figure element at same position as the caption
			prevSibling.parentNode.insertBefore(figureElement, prevSibling);
			
			//figureElement.innerHTML = prevSibling.innerHTML;
			figureElement.appendChild(prevSibling);
			figureElement.appendChild(figureCaption);
			
			// remove the old caption and the previous element
			captions[i].parentNode.removeChild(captions[i]);
		}
	}
}
