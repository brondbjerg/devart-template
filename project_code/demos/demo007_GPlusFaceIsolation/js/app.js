// vars

// start -----------------------

$(document).ready(function() {
	// init app
	var t=setTimeout(init,3000);
});


var proxyServer = "http://localhost/netProxy.aspx";
var hirespx = 1000;
var lorespx = 245;

var gImagePath = "";

var gui;
var PSketch;
var pjs;

var pdata = {
  // set initial, values,
  userImagePath: ''
};

 



(function() {
	window.onSignIn = function(authResult) {
		if (authResult.access_token) {
			$("#detectStatus").text("G+ Signed In");
			//document.body.innerHTML = '';
			gapi.client.load('plus','v1', function(){ 
				var request = gapi.client.plus.people.get({'userId' : 'me'});
				request.execute(function(response) {
					//console.log('ID: ' + response.id);
					//console.log('Display Name: ' + response.displayName);
					//console.log('Image URL: ' + response.image.url);
					//console.log('Profile URL: ' + response.url);
					
					gImagePath = String(response.image.url).substr(0,String(response.image.url).indexOf("sz=")) ;
					signInSuccess();
					
				});
			});
		} else if (authResult.error) {
			//console.log('There was an error: ' + authResult.error);
			$("#detectStatus").text("Error signing into G+");
		}
	};
	var po = document.createElement('script'); po.type = 'text/javascript';
	po.async = true;
	po.src = 'https://apis.google.com/js/client:plusone.js';
	var s = document.getElementsByTagName('script')[0];
	s.parentNode.insertBefore(po, s);
})();

function signInSuccess() {
	
	$("#signinButton").hide();
		
	var img = document.createElement('img');	
	var url = String(proxyServer + "?" + gImagePath + "sz=" + hirespx);
	img.setAttribute('crossOrigin', "anonymous");
	img.setAttribute('src', url);
	img.setAttribute('id', "hiImage");
	
	$("#detectStatus").text("Loading Image");	
	$("#hiresImageHolder").append(img);
	$("#hiImage").load(hiResGImageLoaded);	
}


function hiResGImageLoaded() {
	
	// begin face detection
	doFaceDetect();
	
	// load low res version for illustration
	var loimg = document.createElement('img');
	var url = String(proxyServer + "?" + gImagePath + "sz=" + lorespx);
	loimg.setAttribute('crossOrigin', "anonymous");
	loimg.setAttribute('src', url);
	loimg.setAttribute('id', "loImage");
	
	$("#loresImageHolder").append(loimg);	
	
}

function doFaceDetect() {
	var coords = $('#hiImage').faceDetection({
		complete:function() {
			$("#detectStatus").text("Detection Complete");
		},
		error:function(img, code, message) {
			$("#detectStatus").text("Detection Error");
		}
	});
	
	if (coords.length > 0) {
	
		var dominantFaceIndex = 0;
		var highestFaceArea = 0;
		// check for dominant face in image
		for (var i = 0; i < coords.length; i++) {
			var faceArea = coords[i].width * coords[i].height;
			if (faceArea > highestFaceArea) {
				dominantFaceIndex = i;
			}
		}
		
		var loResScaling = lorespx/hirespx;
		
		$('<div>', {
			'class':'face',
			'css': {
				'position':	'absolute',
				'left':		(coords[dominantFaceIndex].positionX*loResScaling) +'px',
				'top':		(coords[dominantFaceIndex].positionY*loResScaling) +'px',
				'width': 	(coords[dominantFaceIndex].width*loResScaling)		+'px',
				'height': 	(coords[dominantFaceIndex].height*loResScaling)	+'px'
			}
		})
		.appendTo('#loresImageHolder');
		
		$("#detectStatus").text("Dominant Face Detected");
		
		// tell processing where to find the image & face
		addFaceToPortrait(	coords[dominantFaceIndex].positionX,
							coords[dominantFaceIndex].positionY,
							coords[dominantFaceIndex].width,
							coords[dominantFaceIndex].height);
	
	} else {
		$("#detectStatus").text("Sorry, no face detected");
	}
}

function addFaceToPortrait(faceX,faceY,faceW,faceH) {
	pdata.userImagePath = String(proxyServer + "?" + gImagePath + "sz=" + hirespx);
	pdata.faceX = faceX;
	pdata.faceY = faceY;
	pdata.faceW = faceW;
	pdata.faceH = faceH;
}



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





