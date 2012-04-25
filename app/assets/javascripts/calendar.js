$(function(){
	$('span.unavailable_day').closest('td').css('background-color','#ddd');
});

function toggle_description(link){
	parent = $(link).parent();
	parent.children(".hideable").toggle();
	parent.children(".showable").toggle();
	$(link).toggle();
}
/*
$(function(){
	$('span.important_date_no_blocked_day').closest('td').css('background-color','#acd');
});
*/
