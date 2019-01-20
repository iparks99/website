var jQueryScript = document.createElement('script');
jQueryScript.setAttribute('src', 'https://code.jquery.com/jquery-3.3.1.js');
document.head.appendChild(jQueryScript);

$(document).ready(function () {
	$("#slideshow > div:gt(0)").hide();

	setInterval(function() {
		$('#slideshow > div:first')
			.fadeOut(1000)
			.next()
			.fadeIn(1000)
			.end()
			.appendTo('#slideshow');
	}, 3000);
});
