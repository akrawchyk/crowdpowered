/**
 * Events
 */

(function($) {
	// map date & time to deadline ISO 8601 date
	$('#new_event').on('submit', function() {
		var $this = $(this),
		date = $this.find('input[name=date_submit]').val(),
		time = $this.find('input[name=time_submit]').val();

		$this.find('#event_deadline').val(date + 'T' + time);
	});
}).call(this, jQuery);
