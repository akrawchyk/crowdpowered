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
// 2011-10-10T14:48:00
