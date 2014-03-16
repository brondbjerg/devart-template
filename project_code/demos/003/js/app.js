// vars


// start -----------------------

$(document).ready(function() {
	// init app
	var t=setTimeout(init,3000);
});






function initListeners() {		
	$("#intro .doOpen").click(intro_doOpen);
	$("#intro .doClose").click(intro_doClose);

}

function intro_doClose() {
	// show / hide
	$("#intro .doOpen").show();
	$("#intro .doClose").hide();
	$('#project-details').animate({height:$('#details-container #title').height()});
	
}

function intro_doOpen() {
	// show / hide
	$("#intro .doOpen").hide();
	$("#intro .doClose").show();
	$('#project-details').animate({height:$('#details-container').height()});
	
}



var resizeTimer;
$(window).resize(function() {
	resizeTimer && clearTimeout(resizeTimer);
	resizeTimer = setTimeout(doReload, 400);
});

function doReload() {
	Processing.reload();
}


// init
function init() {
	
		
	initListeners();		
}





