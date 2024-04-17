// tabs in codeblocks are messing with the figures
// tabs are not aligned to the divs because the divs have been shifted
//    you can align by putting the tab inside the div
smallImageHeight = 100;				// set the height of flex-sized objects when small 
scrollTopPosition = 0; 				// value saved for links-return-links within a page
referenceTimer = "";					// timer used to toggle the reference object
scrollFlag = 0;  						// counts when scrolling of page occurs due to reference links

/*** Handling the long-press menu ****/
longClickTimer = null;
overRCMenu = false;
mouseX = 0; mouseY = 0;  // allow a little wiggle of the mouse

// this still seems to work if there is no parent -- probably should check for this, though
parent.window.onload = function()
{		
	encapObject = document.body; 
  scrollTopPosition = window.parent.scrollY;  
  
  // add a print button to the title line
	titleObj = encapObject.querySelector(".title");
	
	if(titleObj)  // there is a title 
	{
		// create printer icon 
		printLink = document.createElement('a');
		printLink.classList.add("sameWin");
		printLink.target = "_self";
		printLink.href = "javascript:window.print();"
		printLink.style.marginLeft = "9px";
		printLink.innerHTML = "&#9113";
		
		// stop Quarto from removing the primary header
    titleObj.classList.remove("d-none");
    
		// add printer icon to title
		titleObj.appendChild(printLink);
	}
	
  // change symbols to highlighting
  if(mod && mod == true)  // allow highlighting in all code
  {
    codeBlocks = document.querySelectorAll("pre");
  }
  else  // allow highlighting only when class="mod"
  {
    codeBlocks = document.querySelectorAll("pre.mod");
  }
  for(i=0; i<codeBlocks.length; i++)
	{
	  newHTML = codeBlocks[i].innerHTML;
	  newHTML = newHTML.replace(/«/g, "<b>");
	  newHTML = newHTML.replace(/»/g, "</b>");
	  codeBlocks[i].innerHTML = newHTML;
	}
	
	codeBlockDivs = document.querySelectorAll("[data-tab]");
	for(i=0; i<codeBlockDivs.length; i++)
	{
    par = document.createElement("p");
		par.classList.add("noSelect");
		par.style.textAlign = "left";
		tabSpan = document.createElement("span");
		tabSpan.classList.add("codeBlockTab", "noSelect", "noCode", "nonum");
		tabSpan.setAttribute("data-text", codeBlockDivs[i].getAttribute("data-tab"));
		tabSpan.innerText = codeBlockDivs[i].getAttribute("data-tab");
		par.appendChild(tabSpan);
		codeBlockDivs[i].prepend(tabSpan);
	}
		
	// allow users to resize images from small to full-size
	createFlexImages();
	
	equationNumbering();
	
	// Create a right-click menu
	makeContextMenu();  // needs to happen after divs are created
		
	// check the URL to see if there is a request to go to a specific part of the page
	checkURLForPos();
	
	// target most hyperlinks to a new window
	linksToNewWindow();
	
	// wrap figure and captions together -- for accessibility
//	captionFigures();
			
	// if this page was hyperlinked from elsewhere and a hash tag was added to the link
	if(window.location.hash.slice(1) != "") 
		scrollToElement(window.location.hash.slice(1), true);

	// resize the iframe in the parent window when the page gets resized (if in an iframe)
	if(window !== window.parent && document.body)
	{
		new ResizeObserver(resizeIframeContent).observe(document.body);
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
	// If image is in small sized mode and insruction is not "minimize"
	// The reason I do not put instruction == "minimize" 
	//			has to do with minimize/maximize all call
	if(element.style.height == smallImageHeight + "px" && instruction != "minimize")
	{
		element.style.height = "unset";
	}
	else if (instruction != "maximize")
	{
		// set the images height to the smallHeight value and scale the with to match
		element.style.height = smallImageHeight + "px";	
		element.style.width = "auto";	
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
            element = document.getElementById(hashID);
            // for headers 
            
  			    refElement = document.querySelector("[data-anchor-id='" + String(element.id) + "']");
  			    if(!refElement)
  			    {
  			      // for all but headers
  			      refElement = document.querySelector("#" + element.id);
  			    }
  			    scrollToElement(element.id);
  			  });	
			})(hashID);
		}
		else if (links[i].href.indexOf(window.location.hostname) > -1)
		{
        links[i].target = "_self"; 
		}
		else if(links[i].href.trim() != "" &&                        // link is not blank
		   !(links[i].classList.contains("sameWin")) &&          // link does not contain class sameWin
	//   	 !(links[i].classList.contains("download")) &&         // link does not contain class download
		 	 !(links[i].classList.contains("quarto-xref")) &&      // link does not contain class quarto-xref
		 	 (links[i].target == "_self" || !(links[i].target)) )  // link contains instruction to go to same window
		{
			links[i].target = "_blank";
		}

	}
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
