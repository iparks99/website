var jQueryScript = document.createElement('script');
jQueryScript.setAttribute('src', 'https://code.jquery.com/jquery-3.3.1.js');
document.head.appendChild(jQueryScript);

// Only executes once the DOM is fully loaded.
$(document).ready(function () {
	// Hides every slideshow's images except for its first image.
	$("div[class='slides']").each(function(index) {
		$(this).children("div:gt(0)").hide();
	});

	setInterval(function() {
		$("div[class='slides']").each(function(index) {
			$(this).children("div:first")
				.fadeOut(1000)
				.next()
				.fadeIn(1000)
				.end()
				.appendTo($(this));
		})
	}, 3000);
});
