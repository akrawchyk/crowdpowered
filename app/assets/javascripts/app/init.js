/**
 * Init
 */

$(document).foundation();
$('input.js-pickadate').pickadate({
	min: true,
	formatSubmit: 'yyyy-mm-dd'
});
$('input.js-pickatime').pickatime({
	formatSubmit: 'HH:i:00'
});
