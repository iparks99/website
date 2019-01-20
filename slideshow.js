var jQueryScript = document.createElement('script');
jQueryScript.setAttribute('src', 'https://code.jquery.com/jquery-3.3.1.js');
document.head.appendChild(jQueryScript);

$(document).ready(function () {
	$(".slide").click(function (event) {
		$(this).fadeOut("slow", function () {});
	});
});