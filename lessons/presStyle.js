
// adding a print icon next to the title
/*url = location.protocol + '//' + location.host + location.pathname;
pdf = url.replace(".html", ".pdf");
		// create printer icon 
		title = document.querySelector("h1.title")
		printLink = document.createElement('a');
	//	printLink.classList.add("sameWin");
		printLink.href = pdf; //"javascript:window.print()";
		printLink.style.marginLeft = "9px";
		printLink.innerHTML = "&#9113"; //"&#x1F5B6;";
	
		// add printer icon to title
//alert(title.innerText);		
title.appendChild(printLink);*/

window.onload = function()
{		
  makeFlexImages();
}

function makeFlexImages()
{
  var flexImage = document.querySelectorAll('img');

  for(i=0; i<flexImage.length; i++)	// for each flexSize element
  {
    
  }
}