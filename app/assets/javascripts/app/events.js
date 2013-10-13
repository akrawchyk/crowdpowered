/**
 * Events
 */

(function($) {
	// map date & time to deadline ISO 8601 date
	$('#new_event, .edit_event').on('submit', function() {
		var $this = $(this),
		date = $this.find('input[name=date_submit]').val(),
		time = $this.find('input[name=time_submit]').val();

		$this.find('#event_deadline').val(date + 'T' + time);
	});

	// map deadline to date & time
	var $edit = $('.edit_event');

	if ($edit.length) {
		// initialize date/time picker submit values
		$('#date').change();
		$('#time').change();
	}
}).call(this, jQuery);
